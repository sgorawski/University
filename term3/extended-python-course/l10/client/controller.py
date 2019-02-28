"""
Module implementing controller according to the MVC design pattern,
which binds actions performed by user on views to models methods.
"""

from requests import *


class Controller:

    """Controller class handling user actions."""

    def __init__(self, list_view, add_view, edit_view, switch_views):
        """
        Initializes controller, binds views controls to appropriate methods
        and displays initially list view.

        :param db: instance of the Database class
        :param list_view: instance of the ContactsListView class
        :param add_view: instance of the ContactFieldsView class
        :param edit_view: instance of the ContactFieldsView class
        :param switch_views: function to switch
               between two views in root window
        """
        self.list_view = list_view
        self.add_view = add_view
        self.edit_view = edit_view
        self.switch_views = switch_views

        self.currently_selected_id = None

        # Bindings

        self.list_view.search_btn.bind("<Button-1>", self.search_contacts)
        self.list_view.add_btn.bind("<Button-1>", self.show_add_view)
        self.list_view.edit_btn.bind("<Button-1>", self.show_edit_view)
        self.list_view.delete_btn.bind("<Button-1>", self.delete_contact)

        self.add_view.back_btn.bind("<Button-1>", self.back_from_add_view)
        self.add_view.submit_btn.bind("<Button-1>", self.add_new_contact)

        self.edit_view.back_btn.bind("<Button-1>", self.back_from_edit_view)
        self.edit_view.submit_btn.bind("<Button-1>", self.edit_contact)

        # Initial setup
        self.refresh_list()
        self.list_view.pack()

    def search_contacts(self, event):
        """
        Callback to search input in the list view,
        performs searching by regex defined in database model
        and displays results in the same list view.
        """
        regex = self.list_view.search_text.get()
        if regex:
            self.list_view.set(search_contacts(regex))
        else:
            self.refresh_list()

    def show_add_view(self, event):
        """
        Callback to pressing \"Add\" button in the list view,
        switches to the add view.
        """
        self.list_view.log()
        self.switch_views(self.list_view, self.add_view)

    def show_edit_view(self, event):
        """
        Callback to pressing \"Edit\" button in the list view
        while a contact is selected from the list.
        Switches to the edit view for the selected contact,
        or logs error in the list view console
        if no or more than one contact was selected.
        """
        selection = list(self.list_view.get_selected_contacts_ids())
        if len(selection) != 1:
            self.list_view.log("Select one contact to edit")
            return
        selected_id = selection[0]
        self.currently_selected_id = selected_id

        fields = get_contact_fields(selected_id)[:-1]
        self.edit_view.set_values(*fields)
        self.list_view.log()
        self.switch_views(self.list_view, self.edit_view)

    def back_from_add_view(self, event):
        """
        Callback to pressing \"Back\" button in the add view,
        switches to the list view.
        """
        self.add_view.set_values()
        self.switch_views(self.add_view, self.list_view)

    def back_from_edit_view(self, event):
        """
        Callback to pressing \"Back\" button in the edit view,
        switches to the list view.
        """
        self.edit_view.set_values()
        self.switch_views(self.edit_view, self.list_view)

    def add_new_contact(self, event):
        """
        Callback to pressing \"Submit\" button in the add view,
        maps contact to an instance of the Contact class
        (logs error if it raises one),
        performs adding contact to the database using model,
        and switches to a refreshed list view.
        """
        fields = self.add_view.get_values()
        try:
            add_contact(*fields)
        except ValueError as e:
            self.add_view.log(e)
            return

        self.add_view.set_values()
        self.refresh_list()
        self.switch_views(self.add_view, self.list_view)

    def edit_contact(self, event):
        """
        Callback to pressing \"Submit\" button in the edit view,
        maps contact to an instance of the Contact class
        (logs error if it raises one),
        performs updating contact in the database using model,
        and switches to a refreshed list view.
        """
        fields = self.edit_view.get_values()
        contact_id = self.currently_selected_id
        if contact_id is None:
            raise ValueError("Lost track of selection")

        try:
            update_contact(contact_id, *fields)
        except ValueError as e:
            self.edit_view.log(e)
            return

        self.currently_selected_id = None
        self.refresh_list()
        self.switch_views(self.edit_view, self.list_view)

    def delete_contact(self, event):
        """
        Callback to pressing \"Delete\" button in the list view,
        deletes all selected contacts using database model.
        """
        selected_ids = self.list_view.get_selected_contacts_ids()
        for contact_id in selected_ids:
            delete_contact(contact_id)
        self.refresh_list()

    def refresh_list(self):
        """
        Loads all contacts from the database
        and displays them int he list view.
        """
        self.list_view.search_text.set('')
        self.list_view.set(get_contacts())
