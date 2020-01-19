"""
Main module used to start the application.
To start it, use:

    python3 app.py
"""


from tkinter.ttk import Frame

from views import ContactsListView, ContactFieldsView
from models import Database
from controller import Controller


class Application(Frame):

    """Main application window."""

    def __init__(self, **kwargs):
        """
        Specifies root window parameters,
        creates views, initializes controller.
        """
        super().__init__(**kwargs)

        self.master.title("Contacts manager")
        self.master.geometry("800x300")
        self.pack()

        db = Database("contacts.db")

        list_view = ContactsListView(self)
        add_view = ContactFieldsView(self)
        edit_view = ContactFieldsView(self)

        Controller(db, list_view, add_view, edit_view, self.switch_views)

    @staticmethod
    def switch_views(current_view, new_view):
        """Switches between two views in main window."""
        current_view.pack_forget()
        new_view.pack()


if __name__ == "__main__":
    app = Application()
    app.mainloop()
