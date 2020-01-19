from tkinter.ttk import Frame

from views import ContactsListView, ContactFieldsView
from model import Model
from controller import Controller


class Application(Frame):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)

        self.master.title("Contacts manager")
        self.master.geometry("800x340")
        self.pack()

        model = Model("contacts.db")

        list_view = ContactsListView(self)
        add_view = ContactFieldsView(self)
        edit_view = ContactFieldsView(self)

        Controller(model, list_view, add_view, edit_view, self.switch_views)

    @staticmethod
    def switch_views(current_view, new_view):
        if current_view is not None:
            current_view.pack_forget()
        new_view.pack(pady=20)


app = Application()
app.mainloop()
