open CourseExports__Types;

let decodeProps = json =>
  Json.Decode.(
    json |> field("course", Course.decode),
    json |> field("exports", array(CourseExport.decode)),
    json |> field("tags", array(Tag.decode)),
  );

let (course, exports, tags) =
  DomUtils.parseJSONTag(~id="schools-courses-exports__props", ())
  |> decodeProps;

ReactDOMRe.renderToElementWithId(
  <CourseExports__Root course exports tags />,
  "schools-courses-exports__root",
);
