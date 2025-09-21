import React from "react";
import { ProposalView } from "./pages/ProposalView";

const App: React.FC = () => {
  return (
    <div>
      <h1 style={{ textAlign: "center", marginTop: "2rem" }}>UAH DAO Демография</h1>
      <ProposalView proposalId={1} />
    </div>
  );
};

export default App;