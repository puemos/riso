import React from "react";
import PositionsList from "../modules/positions/components/PositionsList";

const PositionsView: React.SFC<{ path: string }> = React.memo(function() {
  return (
    <div>
      <PositionsList />
    </div>
  );
});

export default PositionsView;
