# Tech Store - E-commerce Application

A simple Flask-based e-commerce application with Bootstrap frontend, connecting to a remote PostgreSQL database.

## Features

- Browse products with supplier information
- Shopping cart functionality
- Customer selection and creation
- Order placement with multiple items
- Responsive Bootstrap UI

## Setup

1. Create and activate virtual environment:
```bash
python3 -m venv venv
source venv/bin/activate  # On macOS/Linux
```

2. Install dependencies:
```bash
pip install -r requirements.txt
```

3. Create `.env` file with your database credentials:
```bash
cp .env.example .env
```
Then edit `.env` and add your PostgreSQL connection string:
```
DATABASE_URI=postgres://username:password@host:port/database?sslmode=require
```

## Running the Application

1. Start the Flask server:
```bash
python app.py
```

2. Open your browser and navigate to:
```
http://localhost:5000
```

## Usage

1. **Select a Customer**: Choose an existing customer from the dropdown or create a new one
2. **Browse Products**: View available products with prices
3. **Add to Cart**: Click "Add to Cart" on products you want to purchase
4. **View Cart**: Click the cart button in the navigation bar
5. **Checkout**: Review your cart and click "Checkout" to place the order

## API Endpoints

- `GET /api/products` - Get all products
- `GET /api/customers` - Get all customers
- `POST /api/customers` - Create a new customer
- `POST /api/orders` - Create a new order
- `GET /api/orders/<customer_id>` - Get orders for a customer

## Tech Stack

- **Backend**: Flask (Python)
- **Database**: PostgreSQL (remote Aiven instance)
- **Frontend**: Bootstrap 5, vanilla JavaScript
- **Database Driver**: psycopg2
