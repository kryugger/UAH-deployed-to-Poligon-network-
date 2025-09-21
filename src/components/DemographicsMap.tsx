import React from "react";
import { MapContainer, TileLayer, Marker, Popup } from "react-leaflet";
import "leaflet/dist/leaflet.css";

interface VoterProfile {
  country: string;
  gender: string;
  ageGroup: string;
  ideology: string;
  religion: string;
}

interface Props {
  profiles: VoterProfile[];
}

export const DemographicsMap: React.FC<Props> = ({ profiles }) => {
  return (
    <div style={{ marginTop: "2rem" }}>
      <h3>🗺️ География голосующих</h3>
      <MapContainer center={[20, 0]} zoom={2} style={{ height: "400px", width: "100%" }}>
        <TileLayer url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png" />
        {profiles.map((p, i) => {
          const coords = getCountryCoords(p.country);
          return (
            <Marker key={i} position={coords}>
              <Popup>
                <strong>{p.country}</strong><br />
                {p.ageGroup}, {p.gender}
              </Popup>
            </Marker>
          );
        })}
      </MapContainer>
    </div>
  );
};

// Пример координат стран
const getCountryCoords = (country: string): [number, number] => {
  const coords: Record<string, [number, number]> = {
    Germany: [51.1657, 10.4515],
    USA: [37.0902, -95.7129],
    India: [20.5937, 78.9629],
    Ukraine: [48.3794, 31.1656]
  };
  return coords[country] || [0, 0];
};