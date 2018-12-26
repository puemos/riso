import React from "react";
import PositionsBoard from "../features/position-board/components/PositionsBoard";

const PositionBoardView: React.SFC<{ path: string; id?: string }> = React.memo(
  function(props) {
    return (
      <div>
        <PositionsBoard id={props.id} />
      </div>
    );
  }
);

export default PositionBoardView;
