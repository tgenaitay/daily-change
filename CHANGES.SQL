CREATE TABLE changes (
  id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  source_id BIGINT NOT NULL REFERENCES sources(id) ON DELETE CASCADE,
  snapshot_id1 BIGINT NOT NULL REFERENCES dom_snapshots(id) ON DELETE CASCADE,
  snapshot_id2 BIGINT NOT NULL REFERENCES dom_snapshots(id) ON DELETE CASCADE,
  diff JSONB NOT NULL,
  classification TEXT CHECK (classification IN ('breaking', 'security', 'performance', 'new_feature', 'minor_fix', 'other')),
  explanation TEXT,
  timestamp TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_changes_source_id ON changes(source_id);
CREATE INDEX idx_changes_snapshot_id1 ON changes(snapshot_id1);
CREATE INDEX idx_changes_snapshot_id2 ON changes(snapshot_id2);
CREATE INDEX idx_changes_classification ON changes(classification);
CREATE INDEX idx_changes_timestamp ON changes(timestamp);
CREATE INDEX idx_changes_explanation_search ON changes USING GIN(to_tsvector('english', explanation));