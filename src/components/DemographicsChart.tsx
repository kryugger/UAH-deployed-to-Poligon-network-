import React from "react";
import { Bar } from "react-chartjs-2";
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  BarElement,
  Tooltip,
  Legend
} from "chart.js";

ChartJS.register(CategoryScale, LinearScale, BarElement, Tooltip, Legend);

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

export const DemographicsChart: React.FC<Props> = ({ profiles }) => {
  const countByField = (field: keyof VoterProfile) => {
    const counts: Record<string, number> = {};
    profiles.forEach((p) => {
      const key = p[field] || "Unknown";
      counts[key] = (counts[key] || 0) + 1;
    });
    return counts;
  };

  const ageData = {
    labels: Object.keys(countByField("ageGroup")),
    datasets: [
      {
        label: "Возрастные группы",
        data: Object.values(countByField("ageGroup")),
        backgroundColor: "#36A2EB"
      }
    ]
  };

  const genderData = {
    labels: Object.keys(countByField("gender")),
    datasets: [
      {
        label: "Пол",
        data: Object.values(countByField("gender")),
        backgroundColor: "#FF6384"
      }
    ]
  };

  return (
    <div style={{ display: "flex", gap: "2rem", flexWrap: "wrap" }}>
      <div style={{ width: "45%" }}>
        <h3>📅 Возраст</h3>
        <Bar data={ageData} />
      </div>
      <div style={{ width: "45%" }}>
        <h3>🧑 Пол</h3>
        <Bar data={genderData} />
      </div>
    </div>
  );
};