import React, { Suspense } from "react";
import PositionsList from "../features/positions/components/PositionsList";

const PositionsView: React.SFC<{ path: string }> = React.memo(function() {
  return (
    <div>
      <Suspense fallback="Loading...">
        <PositionsList />
      </Suspense>
    </div>
  );
});

export default PositionsView;
