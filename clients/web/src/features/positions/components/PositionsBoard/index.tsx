import { loader } from "graphql.macro";
import find from "ramda/es/find";
import propEq from "ramda/es/propEq";
import React, { useState } from "react";
import { useMutation, useQuery } from "react-apollo-hooks";
import { DragDropContext, DropResult } from "react-beautiful-dnd";
import {
  ChangeApplicantStageMutation,
  ChangeApplicantStageVariables,
  DeletePositionStageMutation,
  DeletePositionStageVariables,
  GetPositionQuery,
  GetPositionVariables,
  RemoveApplicantStageMutation,
  RemoveApplicantStageVariables
} from "../../../../generated/types";
import ApplicantForm from "../../../applicants/components/ApplicantForm";
import PositionStageForm from "../PositionStageForm";
import StageColumn from "./StageColumn";
import { updateApplicants } from "./updateApplicants";
import { updateStage } from "./updateStage";

const CHANGE_APPLICANT_STAGE_MUTATION = loader(
  "./changeApplicantStage.graphql"
);
const REMOVE_APPLICANT_STAGE_MUTATION = loader(
  "./removeApplicantStage.graphql"
);
const DELETE_POSITION_STAGE_MUTATION = loader("./deletePositionStage.graphql");
const GET_POSITION_QUERY = loader("./getPosition.graphql");

const UNASSIGN = "UNASSIGN";

type Props = {
  id: string;
};

const PositionsBoard: React.SFC<Props> = React.memo(props => {
  const { id } = props;
  const {
    data: { position },
    refetch
  } = useQuery<GetPositionQuery, GetPositionVariables>(GET_POSITION_QUERY, {
    variables: {
      id: id
    }
  });

  const [stages, setStages] = useState(position!.stages);
  const [applicants, setApplicants] = useState(position!.applicants);

  const changeApplicantStage = useMutation<
    ChangeApplicantStageMutation,
    ChangeApplicantStageVariables
  >(CHANGE_APPLICANT_STAGE_MUTATION);
  const removeApplicantStage = useMutation<
    RemoveApplicantStageMutation,
    RemoveApplicantStageVariables
  >(REMOVE_APPLICANT_STAGE_MUTATION);
  const deletePositionStage = useMutation<
    DeletePositionStageMutation,
    DeletePositionStageVariables
  >(DELETE_POSITION_STAGE_MUTATION);

  async function onDragEnd(dropResult: DropResult) {
    if (!dropResult.destination) {
      return;
    }
    const applicantId = dropResult.draggableId;
    const destinationId = dropResult.destination.droppableId;
    const applicant = find(propEq("id", applicantId), applicants);
    const destinationPositionStage = find(propEq("id", destinationId), stages);

    setStages(
      updateStage(
        stages,
        applicant!,
        destinationPositionStage!,
        dropResult.destination.index
      )
    );
    setApplicants(
      updateApplicants(applicants, applicant!, destinationPositionStage!)
    );

    if (destinationId === UNASSIGN) {
      await removeApplicantStage({
        variables: {
          applicantId
        }
      });
    } else {
      await changeApplicantStage({
        variables: {
          applicantId,
          positionStageId: destinationId
        }
      });
    }
  }
  const refetchPosition = async () => {
    const {
      data: { position }
    } = await refetch();
    setApplicants(position!.applicants);
    setStages(position!.stages);
  };
  const onDeletePositionStage = (id: string) => async () => {
    await deletePositionStage({
      variables: {
        id
      }
    });
    await refetchPosition();
  };

  return (
    <>
      <h2>{position!.title}</h2>
      <PositionStageForm positionId={id} onFinished={refetchPosition} />
      <ApplicantForm positionId={id} onFinished={refetchPosition} />
      <h3>Stages</h3>
      <div
        style={{
          display: "flex",
          justifyContent: "space-between",
          overflowX: "scroll"
        }}
      >
        <DragDropContext onDragEnd={onDragEnd}>
          <StageColumn
            stage={{
              id: UNASSIGN,
              applicants: applicants.filter(applicant => !applicant.stage),
              title: "Pool",
              insertedAt: ""
            }}
          />
          {stages.map(stage => (
            <StageColumn
              key={stage.id}
              stage={stage}
              onDeletePositionStage={onDeletePositionStage}
            />
          ))}
        </DragDropContext>
      </div>
    </>
  );
});

export default PositionsBoard;
