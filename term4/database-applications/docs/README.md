# DBAPP project: Store application sketch

## Business processes

### Creating new order

![img1](img/proc1.png)

### Verifying order status

![img2](img/proc2.png)

## Business entities

- **Customer**
    - Properties:
        - ID
        - Email address
        - First name
        - Last name
        - Phone (optional?)
        - Default address
    - Operations:
        - Register
        - Login / logout
- **Article**
    - Properties:
        - ID
        - Name
        - Description
        - Image (stored as a link to a hostng platform, i.e. AWS S3)
        - Price
        - Availability
    - Operations:
        - Add to cart (frontend-side)
        - Full CRUD for admins only
- **Order**
    - Properties:
        - ID
        - Customer (Foreign key)
        - Articles (Many to many + quantity)
        - Shipment type
        - Delivery address
    - Operations:
        - Create
        - Compute price (sum of articles prices + shipment)
        - Create shipment (use default customer address for shipment by default)
        - Check shipment status
- **Shipment** (_logistics_ app)
    - Properties:
        - Order ID
        - Type (naval, air)
        - Delivery address
        - Timestamp
        - Status
    - Operations:
        - Create
        - Compute price (based on type and address)
    

## Functionalities

- New customers registration
- Logged-in customer session handling
- Articles list display (name, image and price)
- Article details display
- Adding article to cart
- Creating a new order
    - Including shipment price computation from the _logistics_ app
- Customer's orders list display (article name and timestamp?)
- Customer's order detail display
    - Including shimpent status from the _logistics_ app

## Integration

Using a restful API. Endpoints:

For integration with app frontend (UI):
- GET:
    - get customer details by primary key (email address?)
    - get articles' list
    - get article detail by ID
    - get customer's orders' list by customer primary key (email address?)
    - get order detail by ID (with shipment status)
- POST:
    - create a new customer
    - create a new order

For integration with the _logistics_ app:
- GET:
    - get shipment price by type and delivery address
    - get shipment status by order ID
- POST:
    - create a new shipment

## Technology stack

| Component | Technology |
| --- | --- |
| Frontend | SPA: Vue.js or React |
| Backend |  |
| DB engine | PostgreSQL |
| Deployment | VPS? |

## Mockups

TODO
