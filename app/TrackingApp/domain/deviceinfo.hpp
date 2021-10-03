#ifndef DEVICEINFO_HPP
#define DEVICEINFO_HPP

#include <QString>
#include <QObject>
#include <QBluetoothDeviceInfo>

class DeviceInfo: public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString deviceName READ getName NOTIFY deviceChanged)
    Q_PROPERTY(QString deviceRssid READ getRssid NOTIFY deviceChanged)
    Q_PROPERTY(QString deviceAddress READ getAddress NOTIFY deviceChanged)

public:
    DeviceInfo(const QBluetoothDeviceInfo &device);

    void setDevice(const QBluetoothDeviceInfo &device);
    QString getName() const;
    QString getRssid() const;
    QString getAddress() const;
    QBluetoothDeviceInfo getDevice() const;

signals:
    void deviceChanged();

private:
    QBluetoothDeviceInfo m_device;
};

#endif // DEVICEINFO_HPP
