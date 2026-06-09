import os
import json
import requests
import psycopg
from dotenv import load_dotenv

load_dotenv()

API_URL = "https://db.ygoprodeck.com/api/v7/cardinfo.php"

DB_CONFIG = {
    "host": os.getenv("POSTGRES_HOST", "localhost").strip(),
    "port": os.getenv("POSTGRES_PORT", "5432").strip(),
    "dbname": os.getenv("POSTGRES_DB", "yugioh_db").strip(),
    "user": os.getenv("POSTGRES_USER", "yugioh").strip(),
    "password": os.getenv("POSTGRES_PASSWORD", "yugioh_dev_pwd").strip(),
}

def extract_cards() -> list[dict]:
    print("Calling the API")
    response = requests.get(API_URL, timeout=60)
    response.raise_for_status()
    data = response.json()["data"]
    print(f"Cards received: {len(data)}")
    return data

def load_cards(cards: list[dict]) -> None:
    conn = psycopg.connect(
        host=DB_CONFIG["host"],
        port=DB_CONFIG["port"],
        dbname=DB_CONFIG["dbname"],
        user=DB_CONFIG["user"],
        password=DB_CONFIG["password"],
    )
    try:
        with conn.cursor() as cur:
            for card in cards:
                cur.execute(
                    "INSERT INTO raw.cards_raw (card_data) VALUES (%s)",
                    (json.dumps(card),),
                )
        conn.commit()
        print(f"Loaded {len(cards)} cards in raw.cards_raw")
    finally:
        conn.close()
        
def main():
    cards = extract_cards()
    load_cards(cards)
    print("Extraction completed")
    
if __name__ == "__main__":
    main()