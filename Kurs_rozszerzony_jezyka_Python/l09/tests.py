"""
Module implementing tests.
"""

import unittest
import sqlite3
import os

from models import Database, Contact


# noinspection SqlDialectInspection
class DatabaseTests(unittest.TestCase):

    """Tests of the Database class from the models module."""

    test_db_filename = "test_db.db"

    # Helper methods

    def setUp(self):
        """Creates test sqlite3 database and inserts test records."""
        self.test_db = Database(self.test_db_filename)
        self.test_contacts = [
            ("Test1a", "Test1b", "123456789", "test1@test.com", "2017-12-11"),
            ("Test2a", "Test2b", "123456789", "test2@test.com", "2017-12-12"),
            ("NotTo", "BeFound", "987654321", "nope@nope.nope", "2017-12-13"),
        ]
        with sqlite3.connect(self.test_db_filename) as conn:
            c = conn.cursor()
            c.executemany(
                "INSERT INTO Contacts VALUES (?, ?, ?, ?, ?)",
                self.test_contacts,
            )

    def tearDown(self):
        """Deletes test database"""
        os.remove(self.test_db_filename)

    def __fetch_all_contacts_from_db(self):
        """
        Runs query on test database and returns all contacts.

        :return: tuple of contacts fields as tuples
        """
        with sqlite3.connect(self.test_db_filename) as conn:
            c = conn.cursor()
            c.execute("SELECT * FROM Contacts")
            return c.fetchall()

    # Test scenarios

    def test_get_contacts(self):
        """Compares get_contacts method result to test contacts."""
        contacts = [row[1:] for row in self.test_db.get_contacts()]
        self.assertEqual(self.test_contacts, contacts)

    def test_search_contacts(self):
        """
        Searches contacts with regex \"test\"
        and compares to test contacts.
        """
        contacts = [row[1:] for row in self.test_db.search_contacts("test")]
        self.assertEqual(self.test_contacts[:2], contacts)

    def test_get_contact_fields(self):
        """
        Compares get_contact_fields result with actual contact fields from
        test contacts for all rows.
        """
        for test_contact, rowid in zip(self.test_contacts, [1, 2, 3]):
            contact = self.test_db.get_contact_fields(rowid)
            self.assertEqual(test_contact, contact)

    def test_add_contact(self):
        """Adds new contact and checks if it exists in database."""
        new_contact = Contact(
            "New", "Contact", "123456789", "new@mail.com"
        )
        self.test_db.add_contact(new_contact)
        self.assertIn(
            new_contact.get_fields(),
            self.__fetch_all_contacts_from_db(),
        )

    def test_update_contact(self):
        """Updates contact and checks if updated exists in database."""
        updated_contact = Contact(
            "Updated", "Contact", "000000000", "updated@mail.com"
        )
        self.test_db.update_contact(updated_contact, 1)
        self.assertIn(
            updated_contact.get_fields(),
            self.__fetch_all_contacts_from_db(),
        )

    def test_delete_contact(self):
        """
        Deletes contact and checks if it no longer exists in database
        for all test contacts.
        """
        for test_record, rowid in zip(self.test_contacts, [1, 2, 3]):
            self.test_db.delete_contact(rowid)
            self.assertNotIn(
                test_record,
                self.__fetch_all_contacts_from_db(),
            )


class ContactTests(unittest.TestCase):

    """Tests of Contact class from the models module."""

    def test_valid_contact_initialization(self):
        """Creates contact with valid fields and expects no errors."""
        contact_fields = ("Test", "Test", "123456789", "test@test.com")
        try:
            Contact(*contact_fields)
        except ValueError as e:
            self.fail("Valid contact initialization raised %s" % e)

    def test_empty_field_contact_initialization(self):
        """Creates contact with empty field and expects ValueError."""
        contact_fields = ("", "Test", "123456789", "test@test.com")
        self.assertRaises(ValueError, Contact, *contact_fields)

    def test_invalid_phone_contact_initialization(self):
        """Creates contact with invalid phone and expects ValueError."""
        contact_fields = ("Test", "Test", "123456", "test@test.com")
        self.assertRaises(ValueError, Contact, *contact_fields)

    def test_invalid_email_contact_initialization(self):
        """Creates contact with invalid email and expects ValueError."""
        contact_fields = ("Test", "Test", "123456789", "invalid@email")
        self.assertRaises(ValueError, Contact, *contact_fields)


if __name__ == "__main__":
    unittest.main()
