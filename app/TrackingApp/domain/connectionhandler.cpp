#include "connectionhandler.hpp"
#include <QtBluetooth/qtbluetooth-config.h>
#include <QtCore/qsystemdetection.h>

ConnectionHandler::ConnectionHandler(QObject *parent) : QObject(parent)
{
    connect(&m_localDevice, &QBluetoothLocalDevice::hostModeStateChanged,
            this, &ConnectionHandler::hostModeChanged);
}

bool ConnectionHandler::alive() const
{
#if defined(SIMULATOR) || defined(QT_PLATFORM_UIKIT)
    return true;
#else
    return m_localDevice.isValid() && m_localDevice.hostMode() != QBluetoothLocalDevice::HostPoweredOff;
#endif
}

bool ConnectionHandler::requiresAddressType() const
{
#if QT_CONFIG(bluez)
    return true;
#else
    return false;
#endif
}

QString ConnectionHandler::name() const
{
    return m_localDevice.name();
}

QString ConnectionHandler::address() const
{
    return m_localDevice.address().toString();
}

void ConnectionHandler::hostModeChanged(QBluetoothLocalDevice::HostMode /*mode*/)
{
    emit deviceChanged();
}
