import csv
from datetime import datetime
from decimal import Decimal

# Norwegian month names mapping
NORWEGIAN_MONTHS = {
    'januar': 'January',
    'februar': 'February',
    'mars': 'March',
    'april': 'April',
    'mai': 'May',
    'juni': 'June',
    'juli': 'July',
    'august': 'August',
    'september': 'September',
    'oktober': 'October',
    'november': 'November',
    'desember': 'December'
}

# Norwegian day names mapping
NORWEGIAN_DAYS = {
    'mandag': 'Monday',
    'tirsdag': 'Tuesday',
    'onsdag': 'Wednesday',
    'torsdag': 'Thursday',
    'fredag': 'Friday',
    'lørdag': 'Saturday',
    'søndag': 'Sunday'
}

class BitcoinTransaction:
    def __init__(self, date, type, amount, price):
        date = date.lower()
        # Convert Norwegian date to English format
        for no_month, en_month in NORWEGIAN_MONTHS.items():
            if no_month in date:
                date = date.replace(no_month, en_month)
                break
        
        for no_day, en_day in NORWEGIAN_DAYS.items():
            if no_day in date:
                date = date.replace(no_day, en_day)
                break
        
        try:
            self.date = datetime.strptime(date, '%A %d. %B %Y')
        except ValueError:
            # If year is not in the date string, assume current year
            self.date = datetime.strptime(date + ' 2024', '%A %d. %B %Y')
        self.type = type
        self.amount = Decimal(str(amount))
        self.price = Decimal(str(price))

def parse_amount(amount_str):
    if not amount_str:
        return Decimal('0')
    # Remove spaces and 'kr' from the string
    amount_str = amount_str.replace(' ', '').replace('kr', '')
    # Handle all possible minus signs
    if any(minus in amount_str for minus in ['−', '-', '‐', '‑', '–', '—']):
        # Remove any minus sign and add a standard one
        amount_str = '-' + ''.join(c for c in amount_str if c not in ['−', '-', '‐', '‑', '–', '—'])
    # Handle Norwegian number format (comma as decimal separator)
    amount_str = amount_str.replace(',', '.')
    try:
        return Decimal(amount_str)
    except:
        print(f"DEBUG: Failed to parse amount: {amount_str}")
        return Decimal('0')

def parse_btc_amount(btc_str):
    if not btc_str:
        return Decimal('0')
    # Remove spaces and 'BTC' from the string
    btc_str = btc_str.replace(' ', '').replace('BTC', '')
    # Handle all possible minus signs
    if any(minus in btc_str for minus in ['−', '-', '‐', '‑', '–', '—']):
        # Remove any minus sign and add a standard one
        btc_str = '-' + ''.join(c for c in btc_str if c not in ['−', '-', '‐', '‑', '–', '—'])
    # Handle Norwegian number format (comma as decimal separator)
    btc_str = btc_str.replace(',', '.')
    try:
        return Decimal(btc_str)
    except:
        print(f"DEBUG: Failed to parse BTC amount: {btc_str}")
        return Decimal('0')

def calculate_gains():
    transactions = []
    with open('trans.csv', 'r', encoding='utf-8') as file:
        reader = csv.reader(file)
        for row in reader:
            if len(row) >= 5:
                date, type, _, btc_str, kr_str = row[:5]
                # Skip non-Bitcoin transactions
                if type not in ['Autosparing', 'Salg']:
                    continue
                
                print(f"DEBUG: Processing row - Type: {type}, BTC: {btc_str}, Kr: {kr_str}")
                
                # Parse BTC amount first
                btc_amount = parse_btc_amount(btc_str)
                if btc_amount == 0:
                    # If BTC amount is in kr_str, try that instead
                    btc_amount = parse_btc_amount(kr_str)
                    # And get kr amount from btc_str
                    kr_amount = parse_amount(btc_str)
                else:
                    kr_amount = parse_amount(kr_str)
                
                print(f"DEBUG: Parsed values - BTC: {btc_amount}, Kr: {kr_amount}")
                
                if btc_amount != 0:
                    # Calculate price per BTC
                    price = abs(kr_amount / btc_amount)
                    transactions.append(BitcoinTransaction(date, type, abs(btc_amount), price))
                    print(f"DEBUG: Added transaction - Date: {date}, Type: {type}, Amount: {abs(btc_amount)}, Price: {price}")

    # Sort transactions by date
    transactions.sort(key=lambda x: x.date)

    # Track Bitcoin holdings using FIFO
    holdings = []
    gains = []

    print("\nDEBUG: Processing transactions...")
    for transaction in transactions:
        print(f"DEBUG: Processing {transaction.type} - Date: {transaction.date}, Amount: {transaction.amount}, Price: {transaction.price}")
        
        if transaction.type == 'Autosparing':
            # Purchase
            holdings.append({
                'amount': transaction.amount,
                'cost_basis': transaction.price,
                'date': transaction.date
            })
            print(f"DEBUG: Added holding - Amount: {transaction.amount}, Cost Basis: {transaction.price}")
        elif transaction.type == 'Salg':
            # Sale
            remaining_sale_amount = transaction.amount
            print(f"DEBUG: Processing sale of {remaining_sale_amount} BTC at {transaction.price} kr/BTC")
            
            while remaining_sale_amount > 0 and holdings:
                holding = holdings[0]
                print(f"DEBUG: Using holding - Amount: {holding['amount']}, Cost Basis: {holding['cost_basis']}")
                
                if holding['amount'] <= remaining_sale_amount:
                    # Use entire holding
                    gain = (transaction.price - holding['cost_basis']) * holding['amount']
                    gains.append({
                        'date': transaction.date,
                        'amount': holding['amount'],
                        'gain': gain,
                        'purchase_date': holding['date'],
                        'cost_basis': holding['cost_basis'],
                        'sale_price': transaction.price
                    })
                    print(f"DEBUG: Used entire holding - Gain: {gain}")
                    remaining_sale_amount -= holding['amount']
                    holdings.pop(0)
                else:
                    # Use partial holding
                    gain = (transaction.price - holding['cost_basis']) * remaining_sale_amount
                    gains.append({
                        'date': transaction.date,
                        'amount': remaining_sale_amount,
                        'gain': gain,
                        'purchase_date': holding['date'],
                        'cost_basis': holding['cost_basis'],
                        'sale_price': transaction.price
                    })
                    print(f"DEBUG: Used partial holding - Gain: {gain}")
                    holding['amount'] -= remaining_sale_amount
                    remaining_sale_amount = 0

    return gains

def main():
    gains = calculate_gains()
    total_gain = sum(gain['gain'] for gain in gains)
    
    print("\nBitcoin Gains Report for 2024:")
    print("-" * 70)
    for gain in gains:
        print(f"Sale Date: {gain['date'].strftime('%Y-%m-%d')}")
        print(f"Purchase Date: {gain['purchase_date'].strftime('%Y-%m-%d')}")
        print(f"Amount: {gain['amount']:.8f} BTC")
        print(f"Cost Basis: {gain['cost_basis']:.2f} kr/BTC")
        print(f"Sale Price: {gain['sale_price']:.2f} kr/BTC")
        print(f"Gain: {gain['gain']:.2f} kr")
        print("-" * 70)
    
    print(f"\nTotal Gain: {total_gain:.2f} kr")

if __name__ == "__main__":
    main()