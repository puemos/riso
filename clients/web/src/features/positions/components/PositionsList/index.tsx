import { Link } from "@reach/router";
import { loader } from "graphql.macro";
import React from "react";
import { useQuery } from "react-apollo-hooks";
import {
  GetPositionsQuery,
  GetPositionsVariables
} from "../../../../generated/types";
import PositionForm from "../PositionForm";

const POSITIONS_QUERY = loader("./getPositions.graphql");

const PositionsList: React.SFC = React.memo(() => {
  const { data, refetch } = useQuery<GetPositionsQuery, GetPositionsVariables>(
    POSITIONS_QUERY
  );

  return (
    <>
      <PositionForm onFinished={refetch} />
      <ul>
        {data!.positions!.map(position => (
          <li key={position.id}>
            <Link to={`/positions/${position.id}`}>{position.title}</Link>
          </li>
        ))}
      </ul>
    </>
  );
});

export default PositionsList;
