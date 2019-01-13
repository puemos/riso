import { Link } from "@reach/router";
import { loader } from "graphql.macro";
import React from "react";
import { useQuery, useMutation } from "react-apollo-hooks";
import {
  GetPositionsQuery,
  GetPositionsVariables,
  DeletePositionMutation,
  DeletePositionVariables
} from "../../../../generated/types";
import PositionForm from "../PositionForm";

const POSITIONS_QUERY = loader("./getPositions.graphql");
const DELETE_POSITIONS_MUTATION = loader("./deletePosition.graphql");

const PositionsList: React.SFC = React.memo(() => {
  const { data, refetch } = useQuery<GetPositionsQuery, GetPositionsVariables>(
    POSITIONS_QUERY
  );

  const deletePosition = useMutation<
    DeletePositionMutation,
    DeletePositionVariables
  >(DELETE_POSITIONS_MUTATION);

  const onDeletePosition = (positionId: string) => async () => {
    await deletePosition({
      variables: {
        id: positionId
      }
    });
    await refetch();
  };

  return (
    <>
      <PositionForm onFinished={refetch} />
      <ul>
        {data!.positions!.map(position => (
          <li key={position.id}>
            <Link to={`/positions/${position.id}`}>{position.title}</Link>
            <button onClick={onDeletePosition(position.id)}>delete</button>
          </li>
        ))}
      </ul>
    </>
  );
});

export default PositionsList;
