import sqlite3
import datetime
import re


class Model:
    def __init__(self, db_name):
        self.db_name = db_name
        with sqlite3.connect(self.db_name) as conn:
            c = conn.cursor()
            c.execute(
                "CREATE TABLE IF NOT EXISTS Contacts(first_name TEXT, "
                "surname TEXT, phone TEXT, email TEXT, last_edited TEXT)"
            )

    def get_contacts(self):
        with sqlite3.connect(self.db_name) as conn:
            c = conn.cursor()
            c.execute("SELECT rowid, * FROM Contacts")
            return c.fetchall()

    def search_contacts(self, regex):
        with sqlite3.connect(self.db_name) as conn:
            conn.create_function(
                "REGEXP",
                2,
                lambda reg, item: re.search(reg, item, re.I) is not None,
            )
            c = conn.cursor()
            c.execute(
                (
                    "SELECT rowid, * FROM Contacts "
                    "WHERE first_name REGEXP ?1 OR surname REGEXP ?1 "
                    "OR phone REGEXP ?1 OR email REGEXP ?1 "
                    "OR last_edited REGEXP ?1"
                ),
                (regex,),
            )
            return c.fetchall()

    def get_contact_fields(self, rowid):
        with sqlite3.connect(self.db_name) as conn:
            c = conn.cursor()
            c.execute("SELECT * FROM Contacts WHERE rowid = ?", (rowid,))
            return c.fetchone()[:-1]

    def add_contact(self, contact):
        with sqlite3.connect(self.db_name) as conn:
            c = conn.cursor()
            c.execute(
                "INSERT INTO Contacts VALUES (?, ?, ?, ?, ?)",
                contact.get_fields(),
            )

    def update_contact(self, contact, rowid):
        fields = contact.get_fields()
        with sqlite3.connect(self.db_name) as conn:
            c = conn.cursor()
            c.execute(
                (
                    "UPDATE Contacts SET first_name = ?, surname = ?,"
                    "phone = ?, email = ?, last_edited = ? WHERE rowid = ?"
                ),
                (*fields, rowid),
            )

    def delete_contact(self, rowid):
        with sqlite3.connect(self.db_name) as conn:
            c = conn.cursor()
            c.execute("DELETE FROM Contacts WHERE rowid = ?", (rowid,))

    class Contact:
        def __init__(
            self,
            first_name,
            surname,
            phone,
            email,
            last_edited=None,
        ):
            if not first_name or not surname:
                raise ValueError("Fields must not be empty")
            if not phone.isdigit() or len(phone) != 9:
                raise ValueError("Phone number must be 9 digits")
            if not re.match(r"^\w+@\w+\.(\w+\.?)+$", email):
                raise ValueError("Wrong email format")

            if last_edited is None:
                last_edited = datetime.date.today().isoformat()

            self.first_name = first_name
            self.surname = surname
            self.phone = phone
            self.email = email
            self.last_edited = last_edited

        def get_fields(self):
            return (
                self.first_name,
                self.surname,
                self.phone,
                self.email,
                self.last_edited,
            )
