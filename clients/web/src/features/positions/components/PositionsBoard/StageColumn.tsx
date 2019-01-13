import React from "react";
import { Draggable, Droppable } from "react-beautiful-dnd";
import { GetPositionStages } from "../../../../generated/types";
import ApplicantCard from "../ApplicantCard";

type Props = {
  stage: GetPositionStages;
  onDeletePositionStage?: (id: string) => () => Promise<void>;
};

const grid = 18;

const getListStyle = (isDraggingOver: boolean) => ({
  background: isDraggingOver ? "lightblue" : "lightgrey",
  padding: grid,
  width: 250
});

const StageColumn: React.SFC<Props> = React.memo(function(props): JSX.Element {
  const { onDeletePositionStage, stage } = props;
  return (
    <div key={stage.id}>
      <div>
        <span>{stage.title}</span>
        {onDeletePositionStage && (
          <button onClick={onDeletePositionStage(stage.id)}>delete</button>
        )}
      </div>
      <Droppable droppableId={stage.id}>
        {(provided, snapshot) => (
          <div
            ref={provided.innerRef}
            style={getListStyle(snapshot.isDraggingOver)}
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
                      id={applicant.id}
                      name={applicant.name}
                      photo={applicant.photo || undefined}
                      isDragging={snapshot.isDragging}
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
  );
});

export default StageColumn;
