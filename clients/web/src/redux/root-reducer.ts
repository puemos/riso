import { combineReducers } from "redux";
import { StateType } from "typesafe-actions";
import { authReducer } from "../features/auth/reducer";

const rootReducer = combineReducers({
  auth: authReducer
});

export type RootState = StateType<typeof rootReducer>;

export default rootReducer;
