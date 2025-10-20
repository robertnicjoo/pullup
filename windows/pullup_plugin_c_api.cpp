#include "include/pullup/pullup_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "pullup_plugin.h"

void PullupPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  pullup::PullupPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
