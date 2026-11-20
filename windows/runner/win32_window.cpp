#include "win32_window.h"

#include <dwmapi.h>
#include <flutter_windows.h>

namespace {

constexpr const wchar_t kWindowClassName[] = L"FLUTTER_RUNNER_WIN32_WINDOW";

// Scale helper to convert logical (DIP) to physical (pixel) coordinates.
int Scale(int source, double scale_factor) {
  return static_cast<int>(source * scale_factor);
}

}  // namespace

Win32Window::Win32Window() {}

Win32Window::~Win32Window() {
  Destroy();
}

bool Win32Window::Create(const std::wstring &title, const Point &origin,
                        const Size &size) {
  Destroy();

  const wchar_t *window_class_name = kWindowClassName;

  WNDCLASS window_class{};
  window_class.hCursor = LoadCursor(nullptr, IDC_ARROW);
  window_class.lpszClassName = window_class_name;
  window_class.style = CS_HREDRAW | CS_VREDRAW;
  window_class.cbClsExtra = 0;
  window_class.cbWndExtra = 0;
  window_class.hInstance = GetModuleHandle(nullptr);
  window_class.hIcon = LoadIcon(nullptr, IDI_APPLICATION);
  window_class.hbrBackground = 0;
  window_class.lpszMenuName = nullptr;
  window_class.lpfnWndProc = Win32Window::WndProc;
  RegisterClass(&window_class);

  HWND window = CreateWindow(
      window_class_name, title.c_str(), WS_OVERLAPPEDWINDOW | WS_VISIBLE,
      origin.x, origin.y, size.width, size.height, nullptr, nullptr,
      GetModuleHandle(nullptr), this);

  if (!window) {
    return false;
  }

  hwnd_ = window;
  return OnCreate();
}

bool Win32Window::Show() {
  if (!hwnd_) return false;
  ShowWindow(hwnd_, SW_SHOWNORMAL);
  return true;
}

void Win32Window::SetQuitOnClose(bool quit_on_close) {
  quit_on_close_ = quit_on_close;
}

HWND Win32Window::GetHandle() { return hwnd_; }

void Win32Window::SetChildContent(HWND content) {
  child_content_ = content;
  SetParent(content, hwnd_);
  RECT frame = GetClientArea();
  MoveWindow(content, frame.left, frame.top, frame.right - frame.left,
             frame.bottom - frame.top, TRUE);
  SetFocus(content);
}

bool Win32Window::OnCreate() { return true; }

void Win32Window::OnDestroy() {}

void Win32Window::Destroy() {
  if (hwnd_) {
    DestroyWindow(hwnd_);
    hwnd_ = nullptr;
  }
}

LRESULT Win32Window::MessageHandler(HWND hwnd, UINT const message,
                                   WPARAM const wparam,
                                   LPARAM const lparam) noexcept {
  switch (message) {
    case WM_DESTROY:
      if (quit_on_close_) {
        PostQuitMessage(0);
      }
      return 0;
    case WM_SIZE:
      if (child_content_) {
        RECT frame = GetClientArea();
        MoveWindow(child_content_, frame.left, frame.top,
                   frame.right - frame.left, frame.bottom - frame.top, TRUE);
      }
      return 0;
    case WM_ACTIVATE:
      if (child_content_) {
        SetFocus(child_content_);
      }
      return 0;
  }
  return DefWindowProc(hwnd, message, wparam, lparam);
}

LRESULT CALLBACK Win32Window::WndProc(HWND const window, UINT const message,
                                     WPARAM const wparam,
                                     LPARAM const lparam) noexcept {
  if (message == WM_NCCREATE) {
    auto window_struct = reinterpret_cast<CREATESTRUCT *>(lparam);
    SetWindowLongPtr(window, GWLP_USERDATA,
                    reinterpret_cast<LONG_PTR>(window_struct->lpCreateParams));
    auto that = static_cast<Win32Window *>(window_struct->lpCreateParams);
    that->hwnd_ = window;
  } else if (Win32Window *that = GetThisFromHandle(window)) {
    return that->HandleMessage(message, wparam, lparam);
  }
  return DefWindowProc(window, message, wparam, lparam);
}

LRESULT Win32Window::HandleMessage(UINT const message, WPARAM const wparam,
                                  LPARAM const lparam) noexcept {
  return MessageHandler(hwnd_, message, wparam, lparam);
}

Win32Window *Win32Window::GetThisFromHandle(HWND const window) noexcept {
  return reinterpret_cast<Win32Window *>(
      GetWindowLongPtr(window, GWLP_USERDATA));
}

RECT Win32Window::GetClientArea() {
  RECT frame;
  GetClientRect(hwnd_, &frame);
  return frame;
}