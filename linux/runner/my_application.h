#ifndef MY_APPLICATION_H_
#define MY_APPLICATION_H_

#include <gtk/gtk.h>
#include <flutter_linux/flutter_linux.h>

#define MY_APPLICATION_TYPE (my_application_get_type())
G_DECLARE_FINAL_TYPE(MyApplication, my_application, MY, APPLICATION, GtkApplication)

struct _MyApplication {
  GtkApplication parent_instance;
  GtkWindow *window;
  FlView *flutter_view;
  FlDartProject *project;
};

MyApplication *my_application_new();

#endif  // MY_APPLICATION_H_