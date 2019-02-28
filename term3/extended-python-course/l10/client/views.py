"""
Module implementing views for user interaction.
"""


from tkinter import StringVar, RIGHT, LEFT, W, E, BOTH
from tkinter.ttk import Frame, Button, Label, Entry, Treeview


class ContactsListView(Frame):

    """View displaying a list of all contacts."""

    def __init__(self, master, **kwargs):
        """
        Creates list view layout and controls.

        :param master: application root window
        """
        super().__init__(master, **kwargs)

        self.search_text = StringVar()
        self.console_text = StringVar()

        # Treeview setup
        col_ids = ("first_name", "surname", "phone", "email", "last_edited")
        self.contacts_list = Treeview(self, columns=col_ids, show='headings')
        for col_id, text in zip(
                col_ids,
                ["First name", "Surname", "Phone", "Email", "Last edited"]
        ):
            self.contacts_list.column(col_id, stretch=True, width=160)
            self.contacts_list.heading(col_id, text=text)

        # Search panel
        search_panel = Frame(self)
        search_entry = Entry(search_panel, textvariable=self.search_text)
        self.search_btn = Button(search_panel, text="Search")
        search_entry.pack(side=LEFT)
        self.search_btn.pack(side=LEFT)

        # Controls
        self.add_btn = Button(self, text="Add")
        self.edit_btn = Button(self, text="Edit")
        self.delete_btn = Button(self, text="Delete")
        self.console = Label(self, textvariable=self.console_text)

        # Layout
        search_panel.pack()
        self.contacts_list.pack(fill=BOTH, expand=True)
        self.console.pack()
        self.delete_btn.pack(side=RIGHT)
        self.edit_btn.pack(side=RIGHT)
        self.add_btn.pack(side=RIGHT)

    def set(self, contacts):
        """
        Sets contacts to be displayed, clears console.

        :param contacts: collection of contacts fields as tuples
                         with contacts ids
        """
        self.contacts_list.delete(*self.contacts_list.get_children())
        for contact_fields in contacts:
            rowid, values = str(contact_fields[0]), contact_fields[1:]
            self.contacts_list.insert(
                '', 'end', text=rowid, values=values)
        self.log()

    def get_selected_contacts_ids(self):
        """Returns collection of ids."""
        focused_rows = self.contacts_list.selection()
        return map(lambda focus: self.contacts_list.item(focus)['text'],
                   focused_rows)

    def log(self, message=''):
        """Writes message on the console."""
        self.console_text.set(message)


class ContactFieldsView(Frame):

    """View displaying editable fields of a single contact."""

    def __init__(self, master, **kwargs):
        """
        Creates fields view layout and controls,
        binds entries to variables.

        :param master: application root window
        """
        super().__init__(master, **kwargs)

        # Bound field variables
        self.first_name = StringVar()
        self.surname = StringVar()
        self.phone = StringVar()
        self.email = StringVar()

        self.console_text = StringVar()

        # Displaying values and handling entries
        fields = Frame(self)
        for i, (field_name, field_var) in enumerate(zip(
                ["First name:", "Surname:", "Phone:", "Email:"],
                [self.first_name, self.surname, self.phone, self.email]
        )):
            label = Label(fields, text=field_name)
            entry = Entry(fields, textvariable=field_var)

            label.grid(row=i, column=0, sticky=W)
            entry.grid(row=i, column=1, sticky=E)

        # Controls
        self.back_btn = Button(self, text="Back")
        self.submit_btn = Button(self, text="Submit")
        self.console = Label(self, textvariable=self.console_text)

        # Layout
        fields.pack()
        self.console.pack()
        self.back_btn.pack(side=LEFT)
        self.submit_btn.pack(side=RIGHT)

    def set_values(self, first_name="", surname="", phone="", email=""):
        """
        Displays given values in entries - used in edit view;
        clears console.
        """
        for arg_val, var in zip(
                [first_name, surname, phone, email],
                [self.first_name, self.surname, self.phone, self.email]
        ):
            var.set(arg_val)
        self.log()

    def get_values(self):
        """Returns entries values as a tuple."""
        return (self.first_name.get(),
                self.surname.get(),
                self.phone.get(),
                self.email.get())

    def log(self, message=''):
        """Writes message on the console."""
        self.console_text.set(message)
