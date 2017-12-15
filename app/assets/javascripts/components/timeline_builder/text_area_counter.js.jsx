class TimelineBuilderTextAreaCounter extends React.Component {
  constructor(props) {
    super(props);
  }

  counterClasses() {
    let classes = "timeline-builder-social-bar__textarea-counter";

    if (this.textCount() == 500) {
      classes += " timeline-builder-social-bar__textarea-counter--danger";
    } else if (this.textCount() > 400) {
      classes += " timeline-builder-social-bar__textarea-counter--warning";
    }

    return classes;
  }

  textCount() {
    let text = this.props.description.trim();
    return text ? this.byteCount(text) : 0;
  }

  byteCount(string) {
    return encodeURI(string).split(/%..|./).length - 1;
  }

  counterText() {
    let text = this.textCount() + "/500";
    return text;
  }

  render() {
    return (
      <div className="timeline-builder-social-bar__textarea-counter-container pull-left">
        {this.counterText() != "" && (
          <div className={this.counterClasses()}>{this.counterText()}</div>
        )}
      </div>
    );
  }
}

TimelineBuilderTextAreaCounter.propTypes = {
  description: PropTypes.string
};
