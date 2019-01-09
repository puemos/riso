import gql from "graphql-tag";
import React from "react";
import { useQuery, useMutation } from "react-apollo-hooks";
import {
  GetPositionQuery,
  GetPositionVariables,
  ChangeApplicantStageMutation,
  ChangeApplicantStageVariables,
  RemoveApplicantStageMutation,
  RemoveApplicantStageVariables
} from "../../../generated/types";

import {
  DragDropContext,
  Droppable,
  Draggable,
  DropResult
} from "react-beautiful-dnd";
import ApplicantCard from "./ApplicantCard";
import ApplicantForm from "../../applicants/components/ApplicantForm";
import PositionStageForm from "../../positions/components/PositionStageForm";

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

const REMOVE_APPLICANT_STAGE_MUTATION = gql`
  mutation removeApplicantStage($applicantId: ID!) {
    removeApplicantStage(applicantId: $applicantId) {
      successful
    }
  }
`;

type Props = {
  id?: string;
};

const UNASSIGN = "UNASSIGN";

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
  const removeApplicantStage = useMutation<
    RemoveApplicantStageMutation,
    RemoveApplicantStageVariables
  >(REMOVE_APPLICANT_STAGE_MUTATION);

  if (errors) {
    return <div>{`Error! ${errors[0].message}`}</div>;
  }
  if (loading) {
    return <div>Loading...</div>;
  }
  async function onDragEnd(dropResult: DropResult) {
    if (dropResult.destination) {
      const positionStageId = dropResult.destination.droppableId;
      if (positionStageId === UNASSIGN) {
        await removeApplicantStage({
          variables: {
            applicantId: dropResult.draggableId
          }
        });
      } else {
        await changeApplicantStage({
          variables: {
            applicantId: dropResult.draggableId,
            positionStageId: positionStageId
          }
        });
      }

      refetch();
    }
  }
  const position = data!.position!;
  return (
    <>
      <h2>{position.title}</h2>
      <PositionStageForm
        positionId={position.id}
        onFinished={() => {
          refetch();
        }}
      />
      <ApplicantForm
        positionId={position.id}
        onFinished={() => {
          refetch();
        }}
      />
      <div>
        <h3>Stages</h3>
        <DragDropContext onDragEnd={onDragEnd}>
          <div key={"Pool"}>
            <h3>{"Pool"}</h3>
            <Droppable droppableId={UNASSIGN}>
              {(provided, _snapshot) => (
                <div
                  ref={provided.innerRef}
                  style={{
                    minHeight: 50,
                    width: 200,
                    background: "lightgrey"
                  }}
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
                    style={{
                      minHeight: 200,
                      width: 200,
                      background: "lightgrey"
                    }}
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
