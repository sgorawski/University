"""
Module implementing data management,
including connecting to database, running queries
and mapping data to Python objects.
"""

import sqlite3
import datetime
import re


# noinspection SqlDialectInspection
class Database:

    """Connection with sqlite3 database."""

    def __init__(self, db_filename):
        """
        Creates database or connects to an existing one,
        creates table with contacts if there is none.

        :param db_filename: name of database file
        """
        self.db_filename = db_filename
        with sqlite3.connect(self.db_filename) as conn:
            c = conn.cursor()
            c.execute(
                "CREATE TABLE IF NOT EXISTS Contacts(first_name TEXT, "
                "surname TEXT, phone TEXT, email TEXT, last_edited TEXT)"
            )

    def get_contacts(self):
        """
        Runs query on database and returns all contacts with their ids.

        :return: collection of contacts fields (as tuple) with ids
        """
        with sqlite3.connect(self.db_filename) as conn:
            c = conn.cursor()
            c.execute("SELECT rowid, * FROM Contacts")
            return c.fetchall()

    def search_contacts(self, regex):
        """
        Runs query on database and returns all contacts, which fields
        (one or more) match given regular expression.

        :param regex: regular expression to match
        :return: collection of contacts fields (as tuple) with ids
        """
        with sqlite3.connect(self.db_filename) as conn:
            conn.create_function(
                "REGEXP", 2,
                lambda reg, item: re.search(reg, item, re.I) is not None
            )
            c = conn.cursor()
            c.execute("SELECT rowid, * FROM Contacts "
                      "WHERE first_name REGEXP ?1 OR surname REGEXP ?1 "
                      "OR phone REGEXP ?1 OR email REGEXP ?1 "
                      "OR last_edited REGEXP ?1", (regex, ))
            return c.fetchall()

    def get_contact_fields(self, rowid):
        """
        Runs query on database and returns fields of a contact found by id.

        :param rowid: contact id
        :return: contact fields as tuple
        """
        with sqlite3.connect(self.db_filename) as conn:
            c = conn.cursor()
            c.execute("SELECT * FROM Contacts WHERE rowid = ?", (rowid, ))
            return c.fetchone()

    def add_contact(self, contact):
        """
        Adds new contact to database.

        :param contact: instance of the Contact class
        """
        with sqlite3.connect(self.db_filename) as conn:
            c = conn.cursor()
            c.execute("INSERT INTO Contacts VALUES (?, ?, ?, ?, ?)",
                      contact.get_fields())

    def update_contact(self, contact, rowid):
        """
        Updates contact in database found by id.

        :param contact: instance of the Contact class with updated fields
        :param rowid: id of contact to update
        """
        fields = contact.get_fields()
        with sqlite3.connect(self.db_filename) as conn:
            c = conn.cursor()
            c.execute("UPDATE Contacts SET first_name = ?, surname = ?,"
                      "phone = ?, email = ?, last_edited = ? WHERE rowid = ?",
                      fields + (rowid, ))

    def delete_contact(self, rowid):
        """Deletes contact found by id."""
        with sqlite3.connect(self.db_filename) as conn:
            c = conn.cursor()
            c.execute("DELETE FROM Contacts WHERE rowid = ?", (rowid, ))


class Contact:

    """
    Encapsulates contact fields:
    first name, surname, phone, email and last edition date
    and checks if their format is correct.
    """

    def __init__(self, first_name, surname,
                 phone, email, last_edited=None):
        """
        :param first_name: non-empty string
        :param surname: non-empty string
        :param phone: 9 digits
        :param email: standard email address
        :param last_edited: optional date
        """
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
        """Returns contact fields as tuple"""
        return (self.first_name, self.surname, self.phone,
                self.email, self.last_edited)
