"""
Module implementing data management,
including connecting to database, running queries
and mapping data to Python objects.
"""

import sqlite3
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

    def add_contact(self, first_name, surname, phone, email, last_edited):
        """
        Adds new contact to database.
        """
        with sqlite3.connect(self.db_filename) as conn:
            c = conn.cursor()
            c.execute("INSERT INTO Contacts VALUES (?, ?, ?, ?, ?)",
                      (first_name, surname, phone, email, last_edited))

    def update_contact(
            self, rowid, first_name, surname, phone, email, last_edited):
        """
        Updates contact in database found by id.
        """
        with sqlite3.connect(self.db_filename) as conn:
            c = conn.cursor()
            c.execute("UPDATE Contacts SET first_name = ?, surname = ?,"
                      "phone = ?, email = ?, last_edited = ? WHERE rowid = ?",
                      (first_name, surname, phone, email, last_edited, rowid))

    def delete_contact(self, rowid):
        """Deletes contact found by id."""
        with sqlite3.connect(self.db_filename) as conn:
            c = conn.cursor()
            c.execute("DELETE FROM Contacts WHERE rowid = ?", (rowid, ))
