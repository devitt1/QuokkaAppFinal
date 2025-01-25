# Decription

This document describes the Bluetooth interface of the Quokka computing device.

# Services

The device has one service (QUOKKA_SVC_UUID) with UUID: 12345678-1234-5678-1234-56789abcdef0

# Characteristics

The following characteristics are currently known:
```
Identifier: QUOKKA_LED_ON_UUID
UUID: 12345678-1234-5678-1234-56789abcdef1
Description:
Used to turn an LED on the device on or off
Access: Read/Write
Input Type: string
Input Values:
    ON - TODO what does this do?
    OFF - TODO what does this do?
    BLE_CONN - TODO what does this do?
    WIFI_CONN - TODO what does this do?

Identifier: QUOKKA_WIFI_CONFIG_UUID
UUID: 12345678-1234-5678-1234-56789abcdef2
Description:
Used to read or write the wifi configuration to the device
Access: Read/Write
Input Type: JSON string
Input Values:
{
  "ssid":"example_ssid",
  "password":"your password"
}


Identifier: QUOKKA_IP_ADDR_CONFIG_UUID
UUID: 12345678-1234-5678-1234-56789abcdef3
Description:
Used to read the ip configuration assigned to the device
Access: Read only
```

# Other Notes
