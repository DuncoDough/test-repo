from flask import Flask, render_template, request, jsonify
import psycopg2
from psycopg2.extras import RealDictCursor
from datetime import datetime
import os
from dotenv import load_dotenv
 
load_dotenv()
 
app = Flask(__name__)
 
DATABASE_URI = os.getenv('DATABASE_URI')
 
def get_db_connection():
    conn = psycopg2.connect(DATABASE_URI)
    return conn
 
@app.route('/')
def index():
    return render_template('index.html')
 
# Loading customers from database and sending them to the frontend
@app.route('/api/customers', methods = ['GET'])
def get_customers():
    try:
        conn = get_db_connection()
        cursor = conn.cursor(cursor_factory=RealDictCursor)
 
        cursor.execute("""
            SELECT CustomerId, CustomerEmail, CustomerName, CustomerSurname
            FROM Customers
            ORDER BY CustomerName
        """)
 
        customers = cursor.fetchall()
 
        cursor.close()
        conn.close()
        return jsonify(customers)
    except Exception as e:
        return jsonify({'error':str(e)}),500
   
# Create a new customer
@app.route('/api/customers', methods=['POST'])
def create_customer():
    try:
        data = request.json
        conn = get_db_connection()
        cursor = conn.cursor(cursor_factory=RealDictCursor)
 
        cursor.execute("""
            INSERT INTO Customers (CustomerEmail, CustomerName, CustomerSurname)
            VALUES (%s, %s, %s)
            RETURNING CustomerId, CustomerEmail, CustomerName, CustomerSurname
        """,(data['email'],data['name'],data['surname']))
 
        customer = cursor.fetchone()
 
        #committing transaction
        conn.commit()
 
        cursor.close()
        conn.close()
        return jsonify(customer), 201
    except Exception as e:
        return jsonify({'error':str(e)}), 500
 
# Loads the products from the database  
@app.route('/api/products', methods = ['GET'])
def get_products():
    try:
        conn = get_db_connection()
        cursor = conn.cursor(cursor_factory=RealDictCursor)
 
        cursor.execute("""
            SELECT p. productId, p.ProductCode, p.productname, p.productPrice,
                    s.SupplierName
            FROM Products p
            JOIN Suppliers s ON p.SupplierId = s.SupplierId
            ORDER BY p.ProductName
        """)
 
        products = cursor.fetchall()
 
        cursor.close()
        conn.close()
        return jsonify(products)
    except Exception as e:
        return jsonify({'error':str(e)}),500
   
# Create a new order
@app.route('/api/orders', methods=['POST'])
def create_order():
    try:
        data = request.json
        conn = get_db_connection()
        cursor = conn.cursor(cursor_factory=RealDictCursor)
 
        # Begin the transaction explicitly
        conn.autocommit = False
        cursor.execute("""
            INSERT INTO Orders (CustomerId, OrderDate)
            VALUES (%s, %s)
            RETURNING OrderId
        """,(data['customerId'], datetime.now()))
 
        order = cursor.fetchone()
        order_id = order['orderid']
 
        for item in data['items']:
            cursor.execute("""
                INSERT INTO OrderItems (OrderId, ProductId, Quantity)
                VALUES (%s, %s, %s)
            """,(order_id, item['productId'], item['quantity']))
        #Commit the transaction
        conn.commit()
 
        cursor.close()
        conn.close()
        return jsonify({'orderId': order_id, 'message': 'Order created successfully!'}), 201
    except Exception as e:
        if conn:
            conn.rollback()
        return jsonify({'error':str(e)}), 500
 
if(__name__) == '__main__':
    app.run(debug=True, port=4000)