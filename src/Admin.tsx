import { Heading, List } from "grommet";
import React from "react";
import { Link, Route, Switch, useRouteMatch } from "react-router-dom";
import { CreatePostForm } from "./Admin/CreatePost";
import { CreateUserForm } from "./Admin/CreateUser";
import { Header } from "./Header";

// export const Admin = (): JSX.Element => {
//   return (
//     <>
//       <Header />
//       <Heading>ADMIN PAGE</Heading>
//       <CreateUserForm />
//       <CreatePostForm />
//     </>
//   );
// };

interface LinkEntry {
  title: string;
  path: string;
}

export const Admin = (): JSX.Element => {
  let { path, url } = useRouteMatch();

  const options: LinkEntry[] = [
    { title: "Create new posts", path: "new-post" },
    { title: "Create new users", path: "new-user" },
  ];

  return (
    <>
      <Header />
      <Heading>Methods</Heading>
      {/* <ul>
    <li>
      <Link to={`${url}/new-post`}>Create new post</Link>
    </li>
    <li>
      <Link to={`${url}/new-user`}>Create new users</Link>
    </li>
  </ul> */}
      <List
        primaryKey="title"
        margin="medium"
        pad="medium"
        border={"vertical"}
        data={options}
        children={({ title, path }: LinkEntry, index: number) => (
          <Link to={`${url}/${path}`}>{title}</Link>
        )}
      />

      <Switch>
        <Route exact path={path}>
          <></>
        </Route>
        <Route path={`${path}/new-post`}>
          <CreatePostForm />
        </Route>
        <Route path={`${path}/new-user`}>
          <CreateUserForm />
        </Route>
      </Switch>
    </>
  );
};
