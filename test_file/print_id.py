from telethon import TelegramClient
import yaml


api_id = 1234
api_hash = ""

client = TelegramClient("tg_session", api_id, api_hash)

async def main():
    await client.start()

    async for dialog in client.iter_dialogs():
        # 只看群 / 频道 / 超级群
        if dialog.is_group or dialog.is_channel:
            print(f"name={dialog.name!r}, id={dialog.id}")

with client:
    client.loop.run_until_complete(main())