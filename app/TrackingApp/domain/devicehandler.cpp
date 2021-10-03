#include "devicehandler.hpp"
#include "deviceinfo.hpp"
#include <QtEndian>
#include <QRandomGenerator>
#include <QAndroidJniObject>

DeviceHandler::DeviceHandler(QObject *parent) :QObject(parent),
    m_foundHeartRateService(false),
    m_measuring(false)
{

}

void DeviceHandler::setAddressType(AddressType type)
{
    switch (type) {
    case DeviceHandler::AddressType::PublicAddress:
        m_addressType = QLowEnergyController::PublicAddress;
        break;
    case DeviceHandler::AddressType::RandomAddress:
        m_addressType = QLowEnergyController::RandomAddress;
        break;
    }
}

DeviceHandler::AddressType DeviceHandler::addressType() const
{
    if (m_addressType == QLowEnergyController::RandomAddress)
        return DeviceHandler::AddressType::RandomAddress;

    return DeviceHandler::AddressType::PublicAddress;
}

void DeviceHandler::setDevice(DeviceInfo *device)
{
    m_currentDevice = device;

    // Disconnect and delete old connection
    if (m_control) {
        m_control->disconnectFromDevice();
        delete m_control;
        m_control = nullptr;
    }

    // Create new controller and connect it if device available
    if (m_currentDevice) {

        // Make connections
//        m_control = QLowEnergyController::createCentral(m_currentDevice->getDevice(), this);
//        m_control = QLowEnergyController::createPeripheral(this);
//        m_control->setRemoteAddressType(m_addressType);
        //! [Connect-Signals-2]
//        connect(m_control, &QLowEnergyController::serviceDiscovered,
//                this, &DeviceHandler::serviceDiscovered);
//        connect(m_control, &QLowEnergyController::discoveryFinished,
//                this, &DeviceHandler::serviceScanDone);

//        connect(m_control, static_cast<void (QLowEnergyController::*)(QLowEnergyController::Error)>(&QLowEnergyController::error),
//                this, [this](QLowEnergyController::Error error) {
//            Q_UNUSED(error);
//            qDebug("Cannot connect to remote device.");
//        });
//        connect(m_control, &QLowEnergyController::connected, this, [this]() {
//            qDebug("Controller connected. Search services...");
//            m_control->discoverServices();
//        });
//        connect(m_control, &QLowEnergyController::disconnected, this, [this]() {
//            qDebug("LowEnergy controller disconnected");
//        });

        // Connect
//        m_control->connectToDevice();
//        serviceScanDone();

        QString addr =  m_currentDevice->getDevice().address().toString();
        qDebug() << "Thang addr at C++: " << addr;
        qDebug() << "Thang: call java function ";
        QAndroidJniObject javaAddr = QAndroidJniObject::fromString(addr);

        QAndroidJniObject bluetoothLowEnergy;
        bool retVal = bluetoothLowEnergy.callMethod<jint>
                                ("qtconnectivity/BluetoothLowEnergy" // class name
                                , "getBLEadvertisingdata" // method name
                                , "(Ljava/lang/String;)I" // signature
                                ,javaAddr.object<jstring>());
    }
}

void DeviceHandler::startMeasurement()
{
    if (alive()) {
        m_start = QDateTime::currentDateTime();
        m_measuring = true;
        m_measurements.clear();
        emit measuringChanged();
    }
}

void DeviceHandler::stopMeasurement()
{
    m_measuring = false;
    emit measuringChanged();
}


void DeviceHandler::serviceDiscovered(const QBluetoothUuid &gatt)
{
    qDebug()<<" Thang: serviceDiscovered: " << gatt ;
    if (gatt == QBluetoothUuid(QBluetoothUuid::TxPower)) {
        qDebug("Heart Rate service discovered. Waiting for service scan to be done...");
        m_foundHeartRateService = true;
    }
}


void DeviceHandler::serviceScanDone()
{
    qDebug("Service scan done.");

    // Delete old service if available
    if (m_service) {
        delete m_service;
        m_service = nullptr;
    }

    // If heartRateService found, create new service
    if (m_foundHeartRateService)
        m_service = m_control->createServiceObject(QBluetoothUuid(QBluetoothUuid::TxPower), this);

    if (m_service) {
        connect(m_service, &QLowEnergyService::stateChanged, this, &DeviceHandler::serviceStateChanged);
        connect(m_service, &QLowEnergyService::characteristicChanged, this, &DeviceHandler::updateHeartRateValue);
        connect(m_service, &QLowEnergyService::descriptorWritten, this, &DeviceHandler::confirmedDescriptorWrite);
        m_service->discoverDetails();
    } else {
        qDebug("TxPower Service not found.");
    }
}

void DeviceHandler::serviceStateChanged(QLowEnergyService::ServiceState s)
{
    switch (s) {
    case QLowEnergyService::DiscoveringServices:
        qDebug("Discovering services...");
        break;
    case QLowEnergyService::ServiceDiscovered:
    {
        qDebug("Service discovered.");

        const QLowEnergyCharacteristic hrChar = m_service->characteristic(QBluetoothUuid(QBluetoothUuid::HeartRateMeasurement));
        if (!hrChar.isValid()) {
            qDebug("HR Data not found.");
            break;
        }

        m_notificationDesc = hrChar.descriptor(QBluetoothUuid::ClientCharacteristicConfiguration);
        if (m_notificationDesc.isValid())
            m_service->writeDescriptor(m_notificationDesc, QByteArray::fromHex("0100"));

        break;
    }
    default:
        //nothing for now
        break;
    }

    emit aliveChanged();
}

void DeviceHandler::updateHeartRateValue(const QLowEnergyCharacteristic &c, const QByteArray &value)
{
    // ignore any other characteristic change -> shouldn't really happen though
    if (c.uuid() != QBluetoothUuid(QBluetoothUuid::HeartRateMeasurement))
        return;

    auto data = reinterpret_cast<const quint8 *>(value.constData());
    quint8 flags = *data;

    //Heart Rate
    int hrvalue = 0;
    if (flags & 0x1) // HR 16 bit? otherwise 8 bit
        hrvalue = static_cast<int>(qFromLittleEndian<quint16>(data[1]));
    else
        hrvalue = static_cast<int>(data[1]);

    addMeasurement(hrvalue);
}

void DeviceHandler::confirmedDescriptorWrite(const QLowEnergyDescriptor &d, const QByteArray &value)
{
    if (d.isValid() && d == m_notificationDesc && value == QByteArray::fromHex("0000")) {
        //disabled notifications -> assume disconnect intent
        m_control->disconnectFromDevice();
        delete m_service;
        m_service = nullptr;
    }
}

void DeviceHandler::disconnectService()
{
    m_foundHeartRateService = false;

    //disable notifications
    if (m_notificationDesc.isValid() && m_service
            && m_notificationDesc.value() == QByteArray::fromHex("0100")) {
        m_service->writeDescriptor(m_notificationDesc, QByteArray::fromHex("0000"));
    } else {
        if (m_control)
            m_control->disconnectFromDevice();

        delete m_service;
        m_service = nullptr;
    }
}

bool DeviceHandler::measuring() const
{
    return m_measuring;
}

bool DeviceHandler::alive() const
{
    if (m_service)
        return m_service->state() == QLowEnergyService::ServiceDiscovered;

    return false;
}

int DeviceHandler::time() const
{
    return m_start.secsTo(m_stop);
}

void DeviceHandler::addMeasurement(int value)
{
    // If measuring and value is appropriate
    if (m_measuring && value > 30 && value < 250) {

        m_stop = QDateTime::currentDateTime();
        m_measurements << value;
    }
    emit statsChanged();
}
