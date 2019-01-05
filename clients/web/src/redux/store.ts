import { createStore, applyMiddleware, compose } from "redux";
import { createEpicMiddleware } from "redux-observable";
import { composeWithDevTools } from "redux-devtools-extension/logOnlyInProduction";

import rootReducer from "./root-reducer";
import rootEpic from "./root-epic";

const composeEnhancers = composeWithDevTools({});
const epicMiddleware = createEpicMiddleware();

function configureStore(initialState?: {}) {
  const middlewares = [epicMiddleware];
  const enhancer = composeEnhancers(applyMiddleware(...middlewares));
  return createStore(rootReducer, initialState!, enhancer);
}

const store = configureStore();
epicMiddleware.run(rootEpic);

export default store;
