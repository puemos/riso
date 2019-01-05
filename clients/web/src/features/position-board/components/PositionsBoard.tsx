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
import ApplicantCard from "./ApplicantCard";
import ApplicantForm from "../../applicants/components/ApplicantForm";

const GET_POSITION_QUERY = gql`
  query getPosition($id: ID!) {
    position(id: $id) {
      id
      title
      applicants {
        id
        name
        photo
      }
      stages {
        id
        title
        applicants {
          id
          name
          photo
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
  const position = data!.position!;
  return (
    <>
      <h2>{position.title}</h2>
      <ApplicantForm
        positionId={position.id}
        onFinished={() => {
          refetch();
        }}
      />
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
          <div key={"Pool"}>
            <h3>{"Pool"}</h3>
            <Droppable droppableId={"Pool"}>
              {(provided, _snapshot) => (
                <div
                  ref={provided.innerRef}
                  style={{ height: 200, width: 200, background: "lightgrey" }}
                >
                  {position.applicants.map((applicant, index) => (
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
                          <ApplicantCard
                            snapshot={snapshot}
                            applicant={applicant}
                          />
                        </div>
                      )}
                    </Draggable>
                  ))}
                  {provided.placeholder}
                </div>
              )}
            </Droppable>
          </div>
          {position.stages.map(stage => (
            <div key={stage.id}>
              <h3>{stage.title}</h3>
              <Droppable droppableId={stage.id}>
                {(provided, _snapshot) => (
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
                            <ApplicantCard
                              snapshot={snapshot}
                              applicant={applicant}
                            />
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
