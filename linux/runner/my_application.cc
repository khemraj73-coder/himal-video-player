#include "my_application.h"

#include <flutter_linux/flutter_linux.h>

#include <stdlib.h>
#include <unistd.h>

static void my_application_activate(GApplication *application) {
  MyApplication *self = MY_APPLICATION(application);
  GtkWindow *window = GTK_WINDOW(self->window);

  gtk_window_set_default_size(window, 1280, 720);
  gtk_window_set_title(window, "HIMAL Video Player");

  g_application_hold(G_APPLICATION(application));

  if (self->flutter_view == nullptr) {
    self->flutter_view = fl_view_new(self->project);
    gtk_widget_show(GTK_WIDGET(self->flutter_view));
    gtk_container_add(GTK_CONTAINER(window), GTK_WIDGET(self->flutter_view));
  }

  gtk_widget_grab_focus(GTK_WIDGET(self->flutter_view));
  gtk_window_present(window);
}

static void my_application_startup(GApplication *application) {
  MyApplication *self = MY_APPLICATION(application);
  self->project = fl_dart_project_new();
  const char *args[] = {"--enable-impeller"};
  fl_dart_project_set_dart_entrypoint_arguments(self->project, 1, args);
}

static void my_application_init(MyApplication *self) {
  self->window = nullptr;
  self->flutter_view = nullptr;
  self->project = nullptr;
}

static void my_application_dispose(GObject *object) {
  MyApplication *self = MY_APPLICATION(object);
  g_clear_object(&self->project);
  g_clear_object(&self->flutter_view);
  G_OBJECT_CLASS(my_application_parent_class)->dispose(object);
}

G_DEFINE_TYPE(MyApplication, my_application, GTK_TYPE_APPLICATION)

static void my_application_class_init(MyApplicationClass *klass) {
  G_APPLICATION_CLASS(klass)->activate = my_application_activate;
  G_APPLICATION_CLASS(klass)->startup = my_application_startup;
  G_OBJECT_CLASS(klass)->dispose = my_application_dispose;
}

MyApplication *my_application_new() {
  return MY_APPLICATION(g_object_new(my_application_get_type(),
                                    "application-id", "com.himal.videoplayer",
                                    "flags", G_APPLICATION_NON_UNIQUE,
                                    nullptr));
}