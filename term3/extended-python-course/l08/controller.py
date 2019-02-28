class Controller:

    def __init__(self, model, list_view, add_view, edit_view, switch_views):
        self.model = model
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
        self.switch_views(None, self.list_view)

    def search_contacts(self, event):
        self.list_view.log()
        regex = self.list_view.search_text.get()
        if regex:
            found_contacts = self.model.search_contacts(regex)
            self.list_view.set(found_contacts)
            if not found_contacts:
                self.list_view.log("No search results")
        else:
            self.refresh_list()

    def show_add_view(self, event):
        self.list_view.log()
        self.switch_views(self.list_view, self.add_view)

    def show_edit_view(self, event):
        selection = list(self.list_view.get_selected_contacts_ids())
        if len(selection) != 1:
            self.list_view.log("Select one contact to edit")
            return
        selected_id = selection[0]
        self.currently_selected_id = selected_id

        fields = self.model.get_contact_fields(selected_id)
        self.edit_view.set_values(*fields)
        self.list_view.log()
        self.switch_views(self.list_view, self.edit_view)

    def back_from_add_view(self, event):
        self.add_view.set_values()
        self.switch_views(self.add_view, self.list_view)

    def back_from_edit_view(self, event):
        self.edit_view.set_values()
        self.switch_views(self.edit_view, self.list_view)

    def add_new_contact(self, event):
        fields = self.add_view.get_values()
        try:
            new_contact = self.model.Contact(*fields)
        except ValueError as e:
            self.add_view.log(e)
            return

        self.model.add_contact(new_contact)
        self.add_view.set_values()
        self.refresh_list()
        self.switch_views(self.add_view, self.list_view)

    def edit_contact(self, event):
        fields = self.edit_view.get_values()
        try:
            updated_contact = self.model.Contact(*fields)
        except ValueError as e:
            self.edit_view.log(e)
            return

        contact_id = self.currently_selected_id
        if contact_id is None:
            raise ValueError("Lost track of selection")
        self.model.update_contact(updated_contact, contact_id)
        self.currently_selected_id = None
        self.refresh_list()
        self.switch_views(self.edit_view, self.list_view)

    def delete_contact(self, event):
        selected_ids = self.list_view.get_selected_contacts_ids()
        for contact_id in selected_ids:
            self.model.delete_contact(contact_id)
        self.refresh_list()

    def refresh_list(self):
        self.list_view.search_text.set('')
        self.list_view.set(self.model.get_contacts())

