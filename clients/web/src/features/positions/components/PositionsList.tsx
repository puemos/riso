import gql from "graphql-tag";
import React from "react";
import { useQuery } from "react-apollo-hooks";
import { PositionsQuery, PositionsVariables } from "../../../generated/types";
import { Link } from "@reach/router";
import PositionForm from "./PositionForm";
const POSITIONS_QUERY = gql`
  query positions($keywords: String) {
    positions(keywords: $keywords) {
      id
      title
    }
  }
`;

const PositionsList: React.SFC = React.memo(() => {
  const { data, errors, loading, refetch } = useQuery<
    PositionsQuery,
    PositionsVariables
  >(POSITIONS_QUERY, { suspend: false });

  if (errors) {
    return <div>{`Error! ${errors[0].message}`}</div>;
  }
  if (loading) {
    return <div>Loading...</div>;
  }

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
