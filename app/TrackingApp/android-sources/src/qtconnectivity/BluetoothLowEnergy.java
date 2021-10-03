package qtconnectivity;
//import org.altbeacon.beacon.AltBeacon;
import org.altbeacon.beacon.*;

public class BluetoothLowEnergy {
    public int getBLEadvertisingdata(String addr)
    {
       System.out.println("Thang getBLEadvertisingdata");
       System.out.println(addr);
//       BeaconManager beaconManager = BeaconManager.getInstanceForApplication(this);
       System.out.println(BeaconManager.DEFAULT_FOREGROUND_SCAN_PERIOD);
       return 0;
    }
}
