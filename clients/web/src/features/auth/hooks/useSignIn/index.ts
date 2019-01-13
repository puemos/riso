import { loader } from "graphql.macro";
import { useApolloClient, useMutation } from "react-apollo-hooks";
import { SignInMutation, SignInVariables } from "../../../../generated/types";
import { useReduxAction } from "../../../../redux/hooks/use-redux-action";
import { AuthActions } from "../../actions";

const SIGNIN_MUTATION = loader("./signIn.graphql");

export default function useSignIn() {
  const client = useApolloClient();
  const mutation = useMutation<SignInMutation, SignInVariables>(
    SIGNIN_MUTATION
  );
  const loggedIn = useReduxAction(AuthActions.loggedIn);
  const loggedOut = useReduxAction(AuthActions.loggedOut);
  const signIn = async (variables: SignInVariables) => {
    const { data } = await mutation({ variables });
    if (data!.signIn!.result) {
      localStorage.setItem("token", data!.signIn!.result!.token);
      client!.resetStore();
      loggedIn();
      return true;
    } else {
      localStorage.removeItem("token");
      loggedOut();
      return false;
    }
  };
  return signIn;
}
