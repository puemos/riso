declare interface Window {
  __REDUX_DEVTOOLS_EXTENSION__: any;
  __REDUX_DEVTOOLS_EXTENSION_COMPOSE__: any;
}

declare type Maybe<T> = T | null;

declare module "graphql.macro" {
  import { DocumentNode } from "graphql";

  export function loader(path: string): DocumentNode;
  export function gql(path: TemplateStringsArray): DocumentNode;
}
