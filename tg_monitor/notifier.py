import logging
from html import escape
import httpx

logger = logging.getLogger(__name__)
NOTIFICATION_TITLE = "TG 监控提醒"


async def send_feishu_notification(
    webhook_url: str,
    channel_name: str,
    keywords: list[str],
    message_text: str,
    message_time: str,
    message_link: str,
    proxy_url: str = "",
):
    """通过飞书 Webhook 发送通知消息。"""
    # 截断过长的消息
    if len(message_text) > 500:
        message_text = message_text[:500] + "..."

    keywords_str = ", ".join(keywords)

    # 构建飞书卡片消息
    elements = [
        {
            "tag": "div",
            "text": {
                "tag": "lark_md",
                "content": f"**频道**: {channel_name}\n"
                f"**命中关键词**: {keywords_str}\n"
                f"**时间**: {message_time}",
            },
        },
        {"tag": "hr"},
        {
            "tag": "div",
            "text": {
                "tag": "lark_md",
                "content": message_text,
            },
        },
    ]

    if message_link:
        elements.append(
            {
                "tag": "action",
                "actions": [
                    {
                        "tag": "button",
                        "text": {"tag": "plain_text", "content": "查看原消息"},
                        "type": "primary",
                        "url": message_link,
                    }
                ],
            }
        )

    payload = {
        "msg_type": "interactive",
        "card": {
            "header": {
                "title": {
                    "tag": "plain_text",
                    "content": f"TG 监控提醒 - {channel_name}",
                },
                "template": "red",
            },
            "elements": elements,
        },
    }

    try:
        async with httpx.AsyncClient(timeout=10, proxy=proxy_url or None) as http_client:
            resp = await http_client.post(webhook_url, json=payload)
            resp.raise_for_status()
            result = resp.json()
            if result.get("code") == 0:
                logger.info(f"飞书通知发送成功")
            else:
                logger.warning(f"飞书通知响应异常: {result}")
    except Exception as e:
        logger.error(f"飞书通知发送失败: {e}")


def _build_telegram_message(
    channel_name: str,
    keywords: list[str],
    message_text: str,
    message_time: str,
    message_link: str,
) -> str:
    safe_channel_name = escape(channel_name)
    safe_keywords = ", ".join(escape(keyword) for keyword in keywords) or "-"
    safe_message_time = escape(message_time)
    safe_message_text = escape(message_text)

    # Telegram 单条消息上限约 4096 字符，预留元信息长度后截断正文。
    if len(safe_message_text) > 3200:
        safe_message_text = safe_message_text[:3200] + "..."

    lines = [
        f"<b>{NOTIFICATION_TITLE}</b>",
        f"<b>频道</b>: {safe_channel_name}",
        f"<b>命中关键词</b>: {safe_keywords}",
        f"<b>时间</b>: {safe_message_time}",
        "",
        safe_message_text,
    ]

    if message_link:
        safe_message_link = escape(message_link, quote=True)
        lines.extend(["", f'<a href="{safe_message_link}">查看原消息</a>'])

    return "\n".join(lines)


async def send_telegram_notification(
    bot_token: str,
    chat_id: str,
    channel_name: str,
    keywords: list[str],
    message_text: str,
    message_time: str,
    message_link: str,
    proxy_url: str = "",
):
    """通过 Telegram Bot API 发送通知消息。"""
    if not bot_token or not chat_id:
        logger.warning("Telegram 机器人配置不完整，已跳过通知发送")
        return

    text = _build_telegram_message(
        channel_name=channel_name,
        keywords=keywords,
        message_text=message_text,
        message_time=message_time,
        message_link=message_link,
    )
    url = f"https://api.telegram.org/bot{bot_token}/sendMessage"
    payload = {
        "chat_id": chat_id,
        "text": text,
        "parse_mode": "HTML",
        "disable_web_page_preview": True,
    }

    try:
        async with httpx.AsyncClient(timeout=10, proxy=proxy_url or None) as http_client:
            resp = await http_client.post(url, json=payload)
            resp.raise_for_status()
            result = resp.json()
            if result.get("ok"):
                logger.info("Telegram 通知发送成功")
            else:
                logger.warning(f"Telegram 通知响应异常: {result}")
    except Exception as e:
        logger.error(f"Telegram 通知发送失败: {e}")