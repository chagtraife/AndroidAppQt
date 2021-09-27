#include "domain/devicefinder.hpp"

#include "devicehandler.hpp"
#include "deviceinfo.hpp"
#include "QDebug"

DeviceFinder::DeviceFinder(DeviceHandler *handler, QObject *parent):
    m_deviceHandler(handler)
{
    //! [devicediscovery-1]
    m_deviceDiscoveryAgent = new QBluetoothDeviceDiscoveryAgent(this);
    m_deviceDiscoveryAgent->setLowEnergyDiscoveryTimeout(5000);

    connect(m_deviceDiscoveryAgent, &QBluetoothDeviceDiscoveryAgent::deviceDiscovered, this, &DeviceFinder::addDevice);
    connect(m_deviceDiscoveryAgent, static_cast<void (QBluetoothDeviceDiscoveryAgent::*)(QBluetoothDeviceDiscoveryAgent::Error)>(&QBluetoothDeviceDiscoveryAgent::error),
            this, &DeviceFinder::scanError);

    connect(m_deviceDiscoveryAgent, &QBluetoothDeviceDiscoveryAgent::finished, this, &DeviceFinder::scanFinished);
    connect(m_deviceDiscoveryAgent, &QBluetoothDeviceDiscoveryAgent::canceled, this, &DeviceFinder::scanFinished);
    //! [devicediscovery-1]
}

DeviceFinder::~DeviceFinder()
{
    qDeleteAll(m_devices);
    m_devices.clear();
}

void DeviceFinder::startSearch()
{
    m_deviceHandler->setDevice(nullptr);
    qDeleteAll(m_devices);
    m_devices.clear();

    emit devicesChanged();

    //! [devicediscovery-2]
    m_deviceDiscoveryAgent->start(QBluetoothDeviceDiscoveryAgent::LowEnergyMethod);
    //! [devicediscovery-2]

    emit scanningChanged();
    qDebug("Scanning for devices...");
}

//! [devicediscovery-3]
void DeviceFinder::addDevice(const QBluetoothDeviceInfo &device)
{
    qDebug()<< "Thang: addDevice:" + device.name() +" rssid:" + QString::number(device.rssi());

    // If device is LowEnergy-device, add it to the list
    if (device.coreConfigurations() & QBluetoothDeviceInfo::LowEnergyCoreConfiguration) {
        m_devices.append(new DeviceInfo(device));
        emit devicesChanged();
    }
}
//! [devicediscovery-4]

void DeviceFinder::scanError(QBluetoothDeviceDiscoveryAgent::Error error)
{
    if (error == QBluetoothDeviceDiscoveryAgent::PoweredOffError)
        qDebug("The Bluetooth adaptor is powered off.");
    else if (error == QBluetoothDeviceDiscoveryAgent::InputOutputError)
        qDebug("Writing or reading from the device resulted in an error.");
    else
        qDebug("An unknown error has occurred.");
}

void DeviceFinder::scanFinished()
{

    if (m_devices.isEmpty())
        qDebug("No Low Energy devices found.");
    else
        qDebug("Scanning done.");

    emit scanningChanged();
    emit devicesChanged();
}

void DeviceFinder::connectToService(const QString &address)
{
    m_deviceDiscoveryAgent->stop();

    DeviceInfo *currentDevice = nullptr;
    for (QObject *entry : qAsConst(m_devices)) {
        auto device = qobject_cast<DeviceInfo *>(entry);
        if (device && device->getAddress() == address ) {
            currentDevice = device;
            break;
        }
    }

    if (currentDevice)
        m_deviceHandler->setDevice(currentDevice);
}

bool DeviceFinder::scanning() const
{
    return m_deviceDiscoveryAgent->isActive();

}

QVariant DeviceFinder::devices()
{
    return QVariant::fromValue(m_devices);
}
