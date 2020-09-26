from xmlrpc.client import ServerProxy
from datetime import date
from re import match


server = ServerProxy("http://localhost:9000")


def verify_fields(first_name, surname, phone, email):
    if not first_name or not surname:
        raise ValueError("Fields must not be empty")
    if not phone.isdigit() or len(phone) != 9:
        raise ValueError("Phone number must be 9 digits")
    if not match(r"^\w+@\w+\.(\w+\.?)+$", email):
        raise ValueError("Wrong email format")


def get_contacts():
    return server.get_contacts()


def search_contacts(regex):
    return server.search_contacts(regex)


def get_contact_fields(contact_id):
    return server.get_contact_fields(contact_id)


def add_contact(first_name, surname, phone, email):
    verify_fields(first_name, surname, phone, email)
    last_edited = date.today().isoformat()
    server.add_contact(first_name, surname, phone, email, last_edited)


def update_contact(contact_id, first_name, surname, phone, email):
    verify_fields(first_name, surname, phone, email)
    last_edited = date.today().isoformat()
    server.update_contact(
        contact_id, first_name, surname, phone, email, last_edited
    )


def delete_contact(contact_id):
    server.delete_contact(contact_id)
