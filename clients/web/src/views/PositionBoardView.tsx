import React, { Suspense } from "react";
import PositionsBoard from "../features/positions/components/PositionsBoard";

const PositionBoardView: React.SFC<{ path: string; id?: string }> = React.memo(
  function(props) {
    return (
      <div>
        <Suspense fallback="Loading...">
          <PositionsBoard id={props.id!} />
        </Suspense>
      </div>
    );
  }
);

export default PositionBoardView;
