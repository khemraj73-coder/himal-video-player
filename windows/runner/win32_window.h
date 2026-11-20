#ifndef RUNNER_WIN32_WINDOW_H_
#define RUNNER_WIN32_WINDOW_H_

#include <Windows.h>

#include <functional>
#include <memory>
#include <string>

// A class abstraction for a high DPI-aware Win32 Window.
class Win32Window {
 public:
  struct Point {
    unsigned int x;
    unsigned int y;
    Point(unsigned int x, unsigned int y) : x(x), y(y) {}
  };

  struct Size {
    unsigned int width;
    unsigned int height;
    Size(unsigned int width, unsigned int height)
        : width(width), height(height) {}
  };

  Win32Window();
  virtual ~Win32Window();

  bool Create(const std::wstring &title, const Point &origin, const Size &size);
  bool Show();
  void SetQuitOnClose(bool quit_on_close);
  HWND GetHandle();
  void SetChildContent(HWND content);
  RECT GetClientArea();

  virtual LRESULT MessageHandler(HWND window, UINT const message,
                                WPARAM const wparam, LPARAM const lparam) noexcept;

  // Called when the window is created.
  virtual bool OnCreate();
  // Called when the window is destroyed.
  virtual void OnDestroy();

 protected:
  virtual LRESULT HandleMessage(UINT const message, WPARAM const wparam,
                               LPARAM const lparam) noexcept;

  static LRESULT CALLBACK WndProc(HWND const window, UINT const message,
                                 WPARAM const wparam, LPARAM const lparam) noexcept;
  static Win32Window *GetThisFromHandle(HWND const window) noexcept;

  HWND hwnd_ = nullptr;
  bool quit_on_close_ = false;
  std::unique_ptr<POINT> last_mouse_position_;

  // Child content window (e.g., Flutter view).
  HWND child_content_ = nullptr;
};

#endif  // RUNNER_WIN32_WINDOW_H_