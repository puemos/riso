import gql from "graphql-tag";
import React from "react";
import { useQuery, useMutation } from "react-apollo-hooks";
import {
  GetPositionQuery,
  GetPositionVariables,
  ChangeApplicantStageMutation,
  ChangeApplicantStageVariables
} from "../../../generated/types";

import { DragDropContext, Droppable, Draggable } from "react-beautiful-dnd";

const GET_POSITION_QUERY = gql`
  query getPosition($id: ID!) {
    position(id: $id) {
      id
      title
      stages {
        id
        title
        applicants {
          id
          name
        }
      }
    }
  }
`;

const CHANGE_APPLICANT_STAGE_MUTATION = gql`
  mutation changeApplicantStage($applicantId: ID!, $positionStageId: ID!) {
    changeApplicantStage(
      applicantId: $applicantId
      positionStageId: $positionStageId
    ) {
      successful
    }
  }
`;

type Props = {
  id?: string;
};

const PositionsBoard: React.SFC<Props> = React.memo(props => {
  const { data, errors, loading, refetch } = useQuery<
    GetPositionQuery,
    GetPositionVariables
  >(GET_POSITION_QUERY, {
    suspend: false,
    variables: {
      id: props.id!
    }
  });
  const changeApplicantStage = useMutation<
    ChangeApplicantStageMutation,
    ChangeApplicantStageVariables
  >(CHANGE_APPLICANT_STAGE_MUTATION);

  if (loading) {
    return <div>Loading...</div>;
  }
  if (errors) {
    return <div>{`Error! ${errors[0].message}`}</div>;
  }

  return (
    <>
      <h2>{data!.position!.title}</h2>
      <div>
      <h3>Stages</h3>
        <DragDropContext
          onDragEnd={async dropResult => {
            if (dropResult.destination) {
              await changeApplicantStage({
                variables: {
                  applicantId: dropResult.draggableId,
                  positionStageId: dropResult.destination.droppableId
                }
              });
              refetch();
            }
          }}
        >
          {data!.position!.stages.map(stage => (
            <div key={stage.id}>
              <h3>{stage.title}</h3>
              <Droppable droppableId={stage.id}>
                {(provided, snapshot) => (
                  <div
                    ref={provided.innerRef}
                    style={{ height: 200, width: 200, background: "lightgrey" }}
                  >
                    {stage.applicants.map((applicant, index) => (
                      <Draggable
                        key={applicant.id}
                        draggableId={applicant.id}
                        index={index}
                      >
                        {(provided, snapshot) => (
                          <div
                            ref={provided.innerRef}
                            {...provided.draggableProps}
                            {...provided.dragHandleProps}
                          >
                            {applicant.name}
                          </div>
                        )}
                      </Draggable>
                    ))}
                    {provided.placeholder}
                  </div>
                )}
              </Droppable>
            </div>
          ))}
        </DragDropContext>
      </div>
    </>
  );
});

export default PositionsBoard;
