#!/usr/bin/env python3
"""
This script is compiled into a standalone binary via PyInstaller.
It communicates via stdin/stdout: receives SEQ,LAT,LON\n, responds OK SEQ or ERR.
Note: This script is NOT meant to be run directly with the user's Python.
"""

import asyncio, sys
from pymobiledevice3.remote.remote_service_discovery import RemoteServiceDiscoveryService
from pymobiledevice3.services.dvt.dvt_secure_socket_proxy import DvtSecureSocketProxyService
from pymobiledevice3.services.dvt.instruments.location_simulation import LocationSimulation

host = sys.argv[1]
port = int(sys.argv[2])

async def main():
    rsd = RemoteServiceDiscoveryService((host, port))
    await rsd.connect()
    with DvtSecureSocketProxyService(rsd) as dvt:
        sim = LocationSimulation(dvt)
        print("READY", flush=True)
        for raw in sys.stdin:
            line = raw.strip()
            if not line:
                continue
            if line == "QUIT":
                break
            if line == "CLEAR":
                try:
                    sim.clear()
                    print("CLEARED", flush=True)
                except Exception as e:
                    print(f"ERR {e}", flush=True)
                continue
            try:
                seq_s, lat_s, lon_s = line.split(",", 2)
                seq = int(seq_s)
                sim.set(float(lat_s), float(lon_s))
                print(f"OK {seq}", flush=True)
            except Exception as e:
                try:
                    seq = int(line.split(",", 1)[0])
                    print(f"ERR {seq} {e}", flush=True)
                except Exception:
                    print(f"ERR {e}", flush=True)
    await rsd.close()

asyncio.run(main())
