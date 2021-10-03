#ifndef DEVICEHANDLER_HPP
#define DEVICEHANDLER_HPP

#include <QDateTime>
#include <QTimer>
#include <QVector>

#include <QLowEnergyController>
#include <QLowEnergyService>
#include "deviceinfo.hpp"

class DeviceHandler:  public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool measuring READ measuring NOTIFY measuringChanged)
    Q_PROPERTY(bool alive READ alive NOTIFY aliveChanged)
    Q_PROPERTY(int time READ time NOTIFY statsChanged)
    Q_PROPERTY(AddressType addressType READ addressType WRITE setAddressType)

public:
    enum class AddressType {
        PublicAddress,
        RandomAddress
    };
    Q_ENUM(AddressType)

    DeviceHandler(QObject *parent = nullptr);

    void setDevice(DeviceInfo *device);
    void setAddressType(AddressType type);
    AddressType addressType() const;

    bool measuring() const;
    bool alive() const;

    // Statistics
    int time() const;


signals:
    void measuringChanged();
    void aliveChanged();
    void statsChanged();

public slots:
    void startMeasurement();
    void stopMeasurement();
    void disconnectService();

private:
    //QLowEnergyController
    void serviceDiscovered(const QBluetoothUuid &);
    void serviceScanDone();

    //QLowEnergyService
    void serviceStateChanged(QLowEnergyService::ServiceState s);
    void updateHeartRateValue(const QLowEnergyCharacteristic &c,
                              const QByteArray &value);
    void confirmedDescriptorWrite(const QLowEnergyDescriptor &d,
                              const QByteArray &value);

private:
    void addMeasurement(int value);

    QLowEnergyController *m_control = nullptr;
    QLowEnergyService *m_service = nullptr;
    QLowEnergyDescriptor m_notificationDesc;
    DeviceInfo *m_currentDevice = nullptr;

    bool m_foundHeartRateService;
    bool m_measuring;

    // Statistics
    QDateTime m_start;
    QDateTime m_stop;

    QVector<int> m_measurements;
    QLowEnergyController::RemoteAddressType m_addressType = QLowEnergyController::PublicAddress;
};

#endif // DEVICEHANDLER_HPP
