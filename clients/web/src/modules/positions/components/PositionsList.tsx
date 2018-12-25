import React from "react";
import gql from "graphql-tag";
import { useQuery } from "react-apollo-hooks";
import {
  SignInMutation,
  SignInVariables,
  PositionsQuery,
  PositionsVariables
} from "../../../generated/types";

const POSITIONS_QUERY = gql`
  query positions($keywords: String) {
    positions(keywords: $keywords) {
      id
      title
    }
  }
`;

function PositionsList() {
  const { data, errors, loading } = useQuery<
    PositionsQuery,
    PositionsVariables
  >(POSITIONS_QUERY, { suspend: false });

  if (loading) {
    return <div>Loading...</div>;
  }
  if (errors) {
    return <div>{`Error! ${errors[0].message}`}</div>;
  }

  return (
    <ul>
      {data!.positions!.map(position => (
        <li key={position.id!}>{position.title}</li>
      ))}
    </ul>
  );
}

export default PositionsList;
