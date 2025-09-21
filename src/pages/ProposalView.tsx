import React, { useEffect, useState } from "react";
import { ethers } from "ethers";
import { Filters } from "../components/Filters";
import { DemographicsChart } from "../components/DemographicsChart";
import { DemographicsMap } from "../components/DemographicsMap";
import { DAO_ABI, DAO_ADDRESS } from "../constants/contract";

interface VoterProfile {
  country: string;
  gender: string;
  ageGroup: string;
  ideology: string;
  religion: string;
}

export const ProposalView = ({ proposalId }: { proposalId: number }) => {
  const [filters, setFilters] = useState<Record<string, string>>({});
  const [profiles, setProfiles] = useState<VoterProfile[]>([]);

  useEffect(() => {
    const fetchProfiles = async () => {
      const provider = new ethers.BrowserProvider(window.ethereum);
      const contract = new ethers.Contract(DAO_ADDRESS, DAO_ABI, provider);

      const logs = await contract.queryFilter(
        contract.filters.MetadataSubmitted(proposalId)
      );

      const data: VoterProfile[] = await Promise.all(
        logs.map(async (event: any) => {
          const profile = await contract.voterMetadata(proposalId, event.args.voter);
          return {
            country: profile.country,
            gender: profile.gender,
            ageGroup: profile.ageGroup,
            ideology: profile.ideology,
            religion: profile.religion
          };
        })
      );

      setProfiles(data);
    };

    fetchProfiles();
  }, [proposalId]);

  const filteredProfiles = profiles.filter((p) =>
    Object.entries(filters).every(([key, value]) =>
      value ? p[key as keyof VoterProfile] === value : true
    )
  );

  return (
    <div style={{ padding: "2rem" }}>
      <h2>📋 Демография голосующих по предложению #{proposalId}</h2>
      <Filters filters={filters} setFilters={setFilters} />
      <DemographicsChart profiles={filteredProfiles} />
      <DemographicsMap profiles={filteredProfiles} />
    </div>
  );
};